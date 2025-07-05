{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoconf,
  automake116x,
  zlib,
  shadow,
  capabilitiesSupport ? stdenv.hostPlatform.isLinux,
  libcap_ng,
  libxcrypt,
  # Disable this by default because `mount` is setuid. However, we also support
  # "dlopen" as a value here. Note that the nixpkgs setuid wrapper and ld-linux.so will filter out LD_LIBRARY_PATH
  # if you set this to dlopen, so ensure you're accessing it without the wrapper if you depend on that.
  cryptsetupSupport ? false,
  cryptsetup,
  ncursesSupport ? true,
  ncurses,
  pamSupport ? true,
  pam,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  sqlite,
  nlsSupport ? true,
  translateManpages ? true,
  po4a,
  installShellFiles,
  writeSupport ? stdenv.hostPlatform.isLinux,
  shadowSupport ? stdenv.hostPlatform.isLinux,
  gitUpdater,
}:

let
  isMinimal = cryptsetupSupport == false && !nlsSupport && !ncursesSupport && !systemdSupport;
in
stdenv.mkDerivation (finalPackage: rec {
  pname = "util-linux" + lib.optionalString isMinimal "-minimal";
  version = "2.41";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${lib.versions.majorMinor version}/util-linux-${version}.tar.xz";
    hash = "sha256-ge6Ts8/f6318QJDO3rode7zpFB/QtQG2hrP+R13cpMY=";
  };

  patches =
    [
      ./rtcwake-search-PATH-for-shutdown.patch
      # https://github.com/util-linux/util-linux/pull/3013
      ./fix-darwin-build.patch
      # https://github.com/util-linux/util-linux/pull/3479 (fixes https://github.com/util-linux/util-linux/issues/3474)
      ./fix-mount-regression.patch
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
      (fetchurl {
        name = "bits-only-build-when-cpu_set_t-is-available.patch";
        url = "https://lore.kernel.org/util-linux/20250501075806.88759-1-hi@alyssa.is/raw";
        hash = "sha256-G7Cdv8636wJEjgt9am7PaDI8bpSF8sO9bFWEIiAL25A=";
      })
    ];

  # We separate some of the utilities into their own outputs. This
  # allows putting together smaller systems depending on only part of
  # the greater util-linux toolset.
  # Compatibility is maintained by symlinking the binaries from the
  # smaller outputs in the bin output.
  outputs =
    [
      "bin"
      "dev"
      "out"
      "lib"
      "man"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ "mount" ]
    ++ [ "login" ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ "swap" ];
  separateDebugInfo = true;

  postPatch =
    ''
      patchShebangs tests/run.sh tools/all_syscalls tools/all_errnos

      substituteInPlace sys-utils/eject.c \
        --replace "/bin/umount" "$bin/bin/umount"
    ''
    + lib.optionalString shadowSupport ''
      substituteInPlace include/pathnames.h \
        --replace "/bin/login" "${shadow}/bin/login"
    ''
    + lib.optionalString stdenv.hostPlatform.isFreeBSD ''
      substituteInPlace lib/c_strtod.c --replace-fail __APPLE__ __FreeBSD__
      sed -E -i -e '/_POSIX_C_SOURCE/d' -e '/_XOPEN_SOURCE/d' misc-utils/hardlink.c
    '';

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  configureFlags =
    [
      "--localstatedir=/var"
      "--disable-use-tty-group"
      "--enable-fs-paths-default=/run/wrappers/bin:/run/current-system/sw/bin:/sbin"
      "--disable-makeinstall-setuid"
      "--disable-makeinstall-chown"
      "--disable-su" # provided by shadow
      (lib.enableFeature writeSupport "write")
      (lib.enableFeature nlsSupport "nls")
      (lib.withFeatureAs (cryptsetupSupport != false) "cryptsetup" (
        if cryptsetupSupport == true then
          "yes"
        else if cryptsetupSupport == "dlopen" then
          "dlopen"
        else
          throw "invalid cryptsetupSupport value: ${toString cryptsetupSupport}"
      ))
      (lib.withFeature ncursesSupport "ncursesw")
      (lib.withFeature systemdSupport "systemd")
      (lib.withFeatureAs systemdSupport "systemdsystemunitdir" "${placeholder "bin"}/lib/systemd/system/")
      (lib.withFeatureAs systemdSupport "tmpfilesdir" "${placeholder "out"}/lib/tmpfiles.d")
      (lib.withFeatureAs systemdSupport "sysusersdir" "${placeholder "out"}/lib/sysusers.d")
      (lib.enableFeature translateManpages "poman")
      "SYSCONFSTATICDIR=${placeholder "lib"}/lib"
    ]
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "scanf_cv_type_modifier=ms"
    ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
      # These features are all disabled in the freebsd-ports distribution
      "--disable-nls"
      "--disable-ipcrm"
      "--disable-ipcs"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Doesn't build on Darwin, also doesn't really make sense on Darwin
      "--disable-liblastlog2"
    ]
    ++ lib.optionals stdenv.hostPlatform.isStatic [
      # Mandatory shared library.
      "--disable-pam-lastlog2"
    ];

  makeFlags = [
    "usrbin_execdir=${placeholder "bin"}/bin"
    "usrlib_execdir=${placeholder "lib"}/lib"
    "usrsbin_execdir=${placeholder "bin"}/sbin"
  ];

  nativeBuildInputs =
    [
      pkg-config
      installShellFiles
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
      autoconf
      automake116x
    ]
    ++ lib.optionals translateManpages [ po4a ]
    ++ lib.optionals (cryptsetupSupport == "dlopen") [ cryptsetup ];

  buildInputs =
    [
      zlib
      libxcrypt
      sqlite
    ]
    ++ lib.optionals (cryptsetupSupport == true) [ cryptsetup ]
    ++ lib.optionals pamSupport [ pam ]
    ++ lib.optionals capabilitiesSupport [ libcap_ng ]
    ++ lib.optionals ncursesSupport [ ncurses ]
    ++ lib.optionals systemdSupport [ systemd ];

  doCheck = false; # "For development purpose only. Don't execute on production system!"

  enableParallelBuilding = true;

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      moveToOutput bin/mount "$mount"
      moveToOutput bin/umount "$mount"
      ln -svf "$mount/bin/"* $bin/bin/
    ''
    + ''

      moveToOutput sbin/nologin "$login"
      moveToOutput sbin/sulogin "$login"
      prefix=$login _moveSbin
      ln -svf "$login/bin/"* $bin/bin/
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''

      moveToOutput sbin/swapon "$swap"
      moveToOutput sbin/swapoff "$swap"
      prefix=$swap _moveSbin
      ln -svf "$swap/bin/"* $bin/bin/
    ''
    + ''

      ln -svf "$bin/bin/hexdump" "$bin/bin/hd"
      ln -svf "$man/share/man/man1/hexdump.1" "$man/share/man/man1/hd.1"

      installShellCompletion --bash bash-completion/*
    '';

  passthru = {
    updateScript = gitUpdater {
      # No nicer place to find latest release.
      url = "https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git";
      rev-prefix = "v";
      ignoredVersions = "(-rc).*";
    };

    # encode upstream assumption to be used in man-db
    # https://github.com/util-linux/util-linux/commit/8886d84e25a457702b45194d69a47313f76dc6bc
    hasCol = stdenv.hostPlatform.libc == "glibc";
  };

  meta = {
    homepage = "https://www.kernel.org/pub/linux/utils/util-linux/";
    description = "Set of system utilities for Linux";
    changelog = "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v${lib.versions.majorMinor version}/v${version}-ReleaseNotes";
    # https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/tree/README.licensing
    license = with lib.licenses; [
      gpl2Only
      gpl2Plus
      gpl3Plus
      lgpl21Plus
      bsd3
      bsdOriginalUC
      publicDomain
    ];
    maintainers = with lib.maintainers; [ numinit ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "blkid"
      "fdisk"
      "mount"
      "smartcols"
      "uuid"
    ];
    priority = 6; # lower priority than coreutils ("kill") and shadow ("login" etc.) packages
  };
})
