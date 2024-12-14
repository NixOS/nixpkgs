{ version, hash }:
{
  lib,
  stdenv,
  fetchFromGitHub,
  nspr,
  perl,
  zlib,
  sqlite,
  ninja,
  cctools,
  fixDarwinDylibNames,
  buildPackages,
  useP11kit ? true,
  p11-kit,
  # allow FIPS mode. Note that this makes the output non-reproducible.
  # https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/NSS_Tech_Notes/nss_tech_note6
  enableFIPS ? false,
  nixosTests,
  nss_latest,
}:

let
  underscoreVersion = lib.replaceStrings [ "." ] [ "_" ] version;
in
stdenv.mkDerivation rec {
  pname = "nss";
  inherit version;

  src = fetchFromGitHub {
    owner = "nss-dev";
    repo = "nss";
    rev = "NSS_${lib.replaceStrings [ "." ] [ "_" ] version}_RTM";
    inherit hash;
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs =
    [
      perl
      ninja
      (buildPackages.python3.withPackages (ps: with ps; [ gyp ]))
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
      fixDarwinDylibNames
    ];

  buildInputs = [
    zlib
    sqlite
  ];

  propagatedBuildInputs = [ nspr ];

  patches = [
    # Based on http://patch-tracker.debian.org/patch/series/dl/nss/2:3.15.4-1/85_security_load.patch
    ./85_security_load_3.85+.patch
    ./fix-cross-compilation.patch
  ];

  postPatch =
    ''
      patchShebangs .

      for f in coreconf/config.gypi build.sh; do
        substituteInPlace "$f" --replace "/usr/bin/env" "${buildPackages.coreutils}/bin/env"
      done

      substituteInPlace coreconf/config.gypi --replace "/usr/bin/grep" "${buildPackages.coreutils}/bin/env grep"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace coreconf/Darwin.mk --replace '@executable_path/$(notdir $@)' "$out/lib/\$(notdir \$@)"
      substituteInPlace coreconf/config.gypi --replace "'DYLIB_INSTALL_NAME_BASE': '@executable_path'" "'DYLIB_INSTALL_NAME_BASE': '$out/lib'"
    '';

  outputs = [
    "out"
    "dev"
    "tools"
  ];

  buildPhase =
    let
      getArch =
        platform:
        if platform.isx86_64 then
          "x64"
        else if platform.isx86_32 then
          "ia32"
        else if platform.isAarch32 then
          "arm"
        else if platform.isAarch64 then
          "arm64"
        else if platform.isPower && platform.is64bit then
          (if platform.isLittleEndian then "ppc64le" else "ppc64")
        else
          platform.parsed.cpu.name;
      # yes, this is correct. nixpkgs uses "host" for the platform the binary will run on whereas nss uses "host" for the platform that the build is running on
      target = getArch stdenv.hostPlatform;
      host = getArch stdenv.buildPlatform;
    in
    ''
      runHook preBuild

      sed -i 's|nss_dist_dir="$dist_dir"|nss_dist_dir="'$out'"|;s|nss_dist_obj_dir="$obj_dir"|nss_dist_obj_dir="'$out'"|' build.sh
      ./build.sh -v --opt \
        --with-nspr=${nspr.dev}/include:${nspr.out}/lib \
        --system-sqlite \
        --enable-legacy-db \
        --target ${target} \
        -Dhost_arch=${host} \
        -Duse_system_zlib=1 \
        --enable-libpkix \
        -j $NIX_BUILD_CORES \
        ${lib.optionalString enableFIPS "--enable-fips"} \
        ${lib.optionalString stdenv.hostPlatform.isDarwin "--clang"} \
        ${lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) "--disable-tests"}

      runHook postBuild
    '';

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-Wno-error"
      "-DNIX_NSS_LIBDIR=\"${placeholder "out"}/lib/\""
    ]
    ++ lib.optionals stdenv.hostPlatform.is64bit [
      "-DNSS_USE_64=1"
    ]
    ++ lib.optionals stdenv.hostPlatform.isILP32 [
      "-DNS_PTR_LE_32=1" # See RNG_RandomUpdate() in drdbg.c
    ]
  );

  installPhase = ''
    runHook preInstall

    rm -rf $out/private
    find $out -name "*.TOC" -delete
    mv $out/public $out/include

    ln -s lib $out/lib64

    # Upstream issue: https://bugzilla.mozilla.org/show_bug.cgi?id=530672
    # https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/nss/files/nss-3.32-gentoo-fixups.patch?id=af1acce6c6d2c3adb17689261dfe2c2b6771ab8a
    NSS_MAJOR_VERSION=`grep "NSS_VMAJOR" lib/nss/nss.h | awk '{print $3}'`
    NSS_MINOR_VERSION=`grep "NSS_VMINOR" lib/nss/nss.h | awk '{print $3}'`
    NSS_PATCH_VERSION=`grep "NSS_VPATCH" lib/nss/nss.h | awk '{print $3}'`
    PREFIX="$out"

    mkdir -p $out/lib/pkgconfig
    sed -e "s,%prefix%,$PREFIX," \
        -e "s,%exec_prefix%,$PREFIX," \
        -e "s,%libdir%,$PREFIX/lib64," \
        -e "s,%includedir%,$dev/include/nss," \
        -e "s,%NSS_VERSION%,$NSS_MAJOR_VERSION.$NSS_MINOR_VERSION.$NSS_PATCH_VERSION,g" \
        -e "s,%NSPR_VERSION%,4.16,g" \
        pkg/pkg-config/nss.pc.in > $out/lib/pkgconfig/nss.pc
    chmod 0644 $out/lib/pkgconfig/nss.pc

    sed -e "s,@prefix@,$PREFIX," \
        -e "s,@MOD_MAJOR_VERSION@,$NSS_MAJOR_VERSION," \
        -e "s,@MOD_MINOR_VERSION@,$NSS_MINOR_VERSION," \
        -e "s,@MOD_PATCH_VERSION@,$NSS_PATCH_VERSION," \
        pkg/pkg-config/nss-config.in > $out/bin/nss-config
    chmod 0755 $out/bin/nss-config
  '';

  postInstall = lib.optionalString useP11kit ''
    # Replace built-in trust with p11-kit connection
    ln -sf ${p11-kit}/lib/pkcs11/p11-kit-trust.so $out/lib/libnssckbi.so
  '';

  postFixup =
    let
      isCross = stdenv.hostPlatform != stdenv.buildPlatform;
      nss = if isCross then buildPackages.nss.tools else "$out";
    in
    (lib.optionalString enableFIPS (
      ''
        for libname in freebl3 nssdbm3 softokn3
        do libfile="$out/lib/lib$libname${stdenv.hostPlatform.extensions.sharedLibrary}"''
      + (
        if stdenv.hostPlatform.isDarwin then
          ''
            DYLD_LIBRARY_PATH=$out/lib:${nspr.out}/lib \
          ''
        else
          ''
            LD_LIBRARY_PATH=$out/lib:${nspr.out}/lib \
          ''
      )
      + ''
            ${nss}/bin/shlibsign -v -i "$libfile"
        done
      ''
    ))
    + ''
      moveToOutput bin "$tools"
      moveToOutput bin/nss-config "$dev"
      moveToOutput lib/libcrmf.a "$dev" # needed by firefox, for example
      rm -f "$out"/lib/*.a

      runHook postInstall
    '';

  passthru.updateScript = ./update.sh;

  passthru.tests =
    lib.optionalAttrs (lib.versionOlder version nss_latest.version) {
      inherit (nixosTests) firefox-esr;
    }
    // lib.optionalAttrs (lib.versionAtLeast version nss_latest.version) {
      inherit (nixosTests) firefox;
    };

  meta = with lib; {
    homepage = "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS";
    description = "Set of libraries for development of security-enabled client and server applications";
    changelog = "https://github.com/nss-dev/nss/blob/master/doc/rst/releases/nss_${underscoreVersion}.rst";
    maintainers = with maintainers; [
      hexa
      ajs124
    ];
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
