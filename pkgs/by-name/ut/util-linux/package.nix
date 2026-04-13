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
  pamSupport ? lib.meta.availableOn stdenv.hostPlatform pam,
  pam,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  systemdLibs,
  sqlite,
  nlsSupport ? true,
  translateManpages ? true,
  po4a,
  installShellFiles,
  writeSupport ? stdenv.hostPlatform.isLinux,
  shadowSupport ? stdenv.hostPlatform.isLinux,
  coreutils,
  # Doesn't build on Darwin, only makes sense on systems which have pam
  withLastlog ? !stdenv.hostPlatform.isDarwin && lib.meta.availableOn stdenv.hostPlatform pam,
  gitUpdater,
  nixosTests,
}:

# lastlog requires PAM, or else it's broken.
assert withLastlog -> pamSupport;

let
  isMinimal = cryptsetupSupport == false && !nlsSupport && !ncursesSupport && !systemdSupport;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "util-linux" + lib.optionalString isMinimal "-minimal";
  version = "2.42";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${lib.versions.majorMinor finalAttrs.version}/util-linux-${finalAttrs.version}.tar.xz";
    hash = "sha256-NFKyYLuqd11udJrDuyIRF4UAP8H0RJcAJcjaJt+nWOk=";
  };

  # Note: fetchpatch/fetchpatch2 cause infinite recursion with util-linuxMinimal.
  # Prefer fetchurl for the below instead of vendoring patches; it will work.
  patches = [
    # Search $PATH for the shutdown binary instead of hard-coding /sbin/shutdown,
    # which isn't valid on NixOS (and a compatibility link on most other modern
    # distros anyway).
    ./rtcwake-search-PATH-for-shutdown.patch

    # Fix compile of 2.42+ on Darwin.
    # https://lore.kernel.org/util-linux/CAEUYr6ZjVX1bd-xcBGtFN_ZYwQnXDYsw7d1-7sTpF2BbgfrR+g@mail.gmail.com/T/#u
    # Different fix than originally proposed; we just don't compile that file on Darwin now and the previous patch was able to be reverted.
    # See: https://github.com/util-linux/util-linux/commit/6ccf20d2fd8e45eed70bd1b915c0d16f646bf133
    (fetchurl {
      name = "pidfd-utils-linux-only.patch";
      url = "https://github.com/util-linux/util-linux/commit/afdade4a3d8e4e6070343c5576470c575719b81f.patch";
      hash = "sha256-EnHsIhU6jaS4Qm+kQMP2an7Ay08nKbIO0MbU7Y2pwkU=";
    })

    # Musl does not define AT_HANDLE_FID, hard-code it if left undefined.
    # https://github.com/util-linux/util-linux/pull/4203
    (fetchurl {
      name = "fix-musl-nsenter.patch";
      url = "https://github.com/util-linux/util-linux/commit/000aff333e5c3a23967280cb0d6451fbbfc9c91b.patch";
      hash = "sha256-6K3jRr2RsAfHnweBOlMn2F0h8hD3xjZobJ1pSlCQHw8=";
    })

    # `script` is broken with options after non-option args and has new memory leaks
    # https://lore.kernel.org/util-linux/adi3573O-5gr9m2q@per.namespace.at/T/#t
    # https://github.com/util-linux/util-linux/pull/4201
    (fetchurl {
      name = "script-fix-backwards-compat.patch";
      url = "https://github.com/util-linux/util-linux/commit/70507ab9eaed10b8dd77b77d4ea25c11ee726bed.patch";
      hash = "sha256-PpFtv8XOK36npCVSvdgKcxGQmkJtgdyMmlN+4yQuWS8=";
    })
    (fetchurl {
      name = "script-fix-memory-leaks.patch";
      url = "https://github.com/util-linux/util-linux/commit/2f1c12a49500ca7ed9c3d5e80664c1622925456b.patch";
      hash = "sha256-9ZwA6sZwM1rQDoxV5x1KHLWxsFpI5CGWJqubtdEHj/I=";
    })
  ];

  # We separate some of the utilities into their own outputs. This
  # allows putting together smaller systems depending on only part of
  # the greater util-linux toolset.
  # Compatibility is maintained by symlinking the binaries from the
  # smaller outputs in the bin output.
  outputs = [
    "bin"
    "dev"
    "out"
    "lib"
    "man"
    "login"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "mount"
    "swap"
  ]
  ++ lib.optionals withLastlog [
    "lastlog"
  ];
  separateDebugInfo = true;

  postPatch = ''
    patchShebangs tests/run.sh tools/all_syscalls tools/all_errnos

    substituteInPlace sys-utils/eject.c \
      --replace-fail "/bin/umount" "$bin/bin/umount"

    # fix `mount -t` tab completion
    substituteInPlace bash-completion/{blkid,mount,umount} \
      --replace-fail "/lib/modules" "/run/booted-system/kernel-modules/lib/modules"
  ''
  + lib.optionalString shadowSupport ''
    substituteInPlace include/pathnames.h \
      --replace-fail "/bin/login" "${shadow}/bin/login"
  ''
  + lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    substituteInPlace lib/c_strtod.c --replace-fail __APPLE__ __FreeBSD__
    sed -E -i -e '/_POSIX_C_SOURCE/d' -e '/_XOPEN_SOURCE/d' misc-utils/hardlink.c
  '';

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  configureFlags = [
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
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "scanf_cv_type_modifier=ms" ]
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    # These features are all disabled in the freebsd-ports distribution
    "--disable-nls"
    "--disable-ipcrm"
    "--disable-ipcs"
  ]
  ++ lib.optionals (!withLastlog) [
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

  nativeBuildInputs = [
    autoconf
    automake116x
    installShellFiles
    pkg-config
  ]
  ++ lib.optionals translateManpages [ po4a ]
  ++ lib.optionals (cryptsetupSupport == "dlopen") [ cryptsetup ];

  buildInputs = [
    zlib
    libxcrypt
    sqlite
  ]
  ++ lib.optionals (cryptsetupSupport == true) [ cryptsetup ]
  ++ lib.optionals pamSupport [ pam ]
  ++ lib.optionals capabilitiesSupport [ libcap_ng ]
  ++ lib.optionals ncursesSupport [ ncurses ]
  ++ lib.optionals systemdSupport [ systemdLibs ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput sbin/nologin "$login"
    moveToOutput sbin/sulogin "$login"
    prefix=$login _moveSbin
    ln -svf "$login/bin/"* $bin/bin/

    ln -svf "$bin/bin/hexdump" "$bin/bin/hd"
    ln -svf "$man/share/man/man1/hexdump.1" "$man/share/man/man1/hd.1"

    rm -f bash-completion/Makemodule.am
    installShellCompletion --bash bash-completion/*
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    moveToOutput bin/mount "$mount"
    moveToOutput bin/umount "$mount"
    ln -svf "$mount/bin/"* $bin/bin/

    moveToOutput sbin/swapon "$swap"
    moveToOutput sbin/swapoff "$swap"
    prefix=$swap _moveSbin
    ln -svf "$swap/bin/"* $bin/bin/
  ''
  + lib.optionalString withLastlog ''
    ${lib.optionalString (!stdenv.hostPlatform.isStatic) ''moveToOutput "lib/security" "$lastlog"''}
    moveToOutput "lib/tmpfiles.d/lastlog2-tmpfiles.conf" "$lastlog"

    moveToOutput "bin/lastlog2" "$lastlog"
    ln -svf "$lastlog/bin/"* $bin/bin/
  ''
  + lib.optionalString (withLastlog && systemdSupport) ''
    moveToOutput "lib/systemd/system/lastlog2-import.service" "$lastlog"
    substituteInPlace $lastlog/lib/systemd/system/lastlog2-import.service \
      --replace-fail "/usr/bin/mv" "${lib.getExe' coreutils "mv"}" \
      --replace-fail "$bin/bin/lastlog2" "$lastlog/bin/lastlog2"
  '';

  doCheck = false; # "For development purpose only. Don't execute on production system!"

  passthru = {
    # encode upstream assumption to be used in man-db
    # https://github.com/util-linux/util-linux/commit/8886d84e25a457702b45194d69a47313f76dc6bc
    hasCol = stdenv.hostPlatform.libc == "glibc";

    tests = {
      inherit (nixosTests) pam-lastlog;
    };
  }
  // lib.optionalAttrs (!isMinimal) {
    updateScript = gitUpdater {
      # No nicer place to find latest release.
      url = "https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git";
      rev-prefix = "v";
      ignoredVersions = "(-rc|-start|-devel).*";
    };
  };

  meta = {
    homepage = "https://www.kernel.org/pub/linux/utils/util-linux/";
    description = "Set of system utilities for Linux";
    changelog = "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v${lib.versions.majorMinor finalAttrs.version}/v${finalAttrs.version}-ReleaseNotes";
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
    teams = [ lib.teams.security-review ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "blkid"
      "fdisk"
      "mount"
      "smartcols"
      "uuid"
    ];
    priority = 6; # lower priority than coreutils ("kill") and shadow ("login" etc.) packages

    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "kernel" finalAttrs.version;
  };
})
