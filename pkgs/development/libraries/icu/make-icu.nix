{
  stdenv,
  lib,
  buildPackages,
  fetchurl,
  fixDarwinDylibNames,
  testers,
  updateAutotoolsGnuConfigScriptsHook,
}:

{
  version,
  hash,
  patches ? [ ],
  patchFlags ? [ ],
  withStatic ? stdenv.hostPlatform.isStatic,
}:

let
  # Cross-compiled icu4c requires a build-root of a native compile
  nativeBuildRoot = buildPackages."icu${lib.versions.major version}".buildRootOnly;

  pname = "icu4c";

  release = lib.replaceStrings [ "." ] [ "-" ] version;
  # To test rc versions of ICU replace the line above with the line below.
  #release = lib.replaceStrings [ "." ] [ "-" ] (
  #  if lib.hasSuffix "rc" version then lib.replaceStrings [ "1" ] [ "" ] version else version
  #);

  baseAttrs = {
    src = fetchurl {
      url =
        if lib.versionAtLeast version "78.1" then
          "https://github.com/unicode-org/icu/releases/download/release-${version}/icu4c-${version}-sources.tgz"
        else
          "https://github.com/unicode-org/icu/releases/download/release-${release}/icu4c-${
            lib.replaceStrings [ "." ] [ "_" ] version
          }-src.tgz";
      inherit hash;
    };

    postUnpack = ''
      sourceRoot=''${sourceRoot}/source
      echo Source root reset to ''${sourceRoot}
    '';

    postPatch =
      lib.optionalString
        (
          (stdenv.hostPlatform.libc == "glibc" || stdenv.hostPlatform.libc == "musl")
          && lib.versionOlder version "62.1"
        )
        ''
          # https://sourceware.org/glibc/wiki/Release/2.26#Removal_of_.27xlocale.h.27
          substituteInPlace i18n/digitlst.cpp --replace '<xlocale.h>' '<locale.h>'
        ''
      # ICU <= 67 hard-codes `-std=c++11` for MinGW in `config/mh-mingw64`.
      # With GCC 15's libstdc++ headers, this breaks due to `__float128` hex-float
      # literals (and the `Q` suffix) used in <limits>. MSYS2 builds ICU with a
      # GNU dialect by default; we align with that for MinGW. Use a modern C++
      # dialect to avoid downgrading newer ICU releases that require C++17+.
      + lib.optionalString stdenv.hostPlatform.isMinGW ''
        substituteInPlace config/mh-mingw64 \
          --replace '-std=c++11' '-std=gnu++17'
      '';

    inherit patchFlags patches;

    preConfigure = ''
      sed -i -e "s|/bin/sh|${stdenv.shell}|" configure

      # $(includedir) is different from $(prefix)/include due to multiple outputs
      sed -i -e 's|^\(CPPFLAGS = .*\) -I\$(prefix)/include|\1 -I$(includedir)|' config/Makefile.inc.in
    ''
    + lib.optionalString stdenv.hostPlatform.isMinGW ''
      # ICU's autotools `configure` (observed in ICU 67.1) appends `-std=c++11`
      # if no `-std=` is present in `$CXXFLAGS`. With GCC 15's libstdc++ headers,
      # strict C++11 fails because <limits> uses `__float128` hex-float literals
      # (and the `Q` suffix).
      #
      # Ensure *some* `-std=` is present so `configure` doesn't inject
      # `-std=c++11` into generated makefiles (e.g. `icudefs.mk`). Pick a modern
      # GNU dialect so we don't downgrade newer ICU releases that require C++17+.
      if ! echo " $CXXFLAGS " | grep -qE ' -std='; then
        export CXXFLAGS="$CXXFLAGS -std=gnu++17"
      fi
    ''
    + lib.optionalString stdenv.hostPlatform.isAarch32 ''
      # From https://archlinuxarm.org/packages/armv7h/icu/files/icudata-stdlibs.patch
      sed -e 's/LDFLAGSICUDT=-nodefaultlibs -nostdlib/LDFLAGSICUDT=/' -i config/mh-linux
    '';

    # Some ICU releases/build fragments (incl. ICU 67.x) use `-std=c++11` for
    # MinGW builds; with GCC 15's libstdc++ headers, `__float128` literals may
    # require enabling extended numeric literal suffixes.
    NIX_CXXFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isMinGW "-fext-numeric-literals";

    dontDisableStatic = withStatic;

    configureFlags = [
      "--disable-debug"
    ]
    ++ lib.optional (stdenv.hostPlatform.isFreeBSD || stdenv.hostPlatform.isDarwin) "--enable-rpath"
    ++ lib.optional (
      stdenv.buildPlatform != stdenv.hostPlatform
    ) "--with-cross-build=${nativeBuildRoot}"
    ++ lib.optional withStatic "--enable-static";

    enableParallelBuilding = true;

    meta = {
      description = "Unicode and globalization support library";
      homepage = "https://icu.unicode.org/";
      maintainers = with lib.maintainers; [ raskin ];
      pkgConfigModules = [
        "icu-i18n"
        "icu-io"
        "icu-uc"
      ];
      platforms = lib.platforms.all;
    };
  };

  realAttrs = baseAttrs // {
    inherit pname version;

    outputs = [
      "out"
      "dev"
    ]
    ++ lib.optional withStatic "static";
    outputBin = "dev";

    nativeBuildInputs = [
      updateAutotoolsGnuConfigScriptsHook
    ]
    ++
      # FIXME: This fixes dylib references in the dylibs themselves, but
      # not in the programs in $out/bin.
      lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

    # remove dependency on bootstrap-tools in early stdenv build
    postInstall =
      lib.optionalString withStatic ''
        mkdir -p $static/lib
        mv -v lib/*.a $static/lib
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        sed -i 's/INSTALL_CMD=.*install/INSTALL_CMD=install/' $out/lib/icu/${lib.versions.majorMinor version}/pkgdata.inc
      ''
      + (
        let
          replacements = [
            {
              from = "\${prefix}/include";
              to = "${placeholder "dev"}/include";
            } # --cppflags-searchpath
            {
              from = "\${pkglibdir}/Makefile.inc";
              to = "${placeholder "dev"}/lib/icu/Makefile.inc";
            } # --incfile
            {
              from = "\${pkglibdir}/pkgdata.inc";
              to = "${placeholder "dev"}/lib/icu/pkgdata.inc";
            } # --incpkgdatafile
          ];
        in
        ''
          rm $out/share/icu/${lib.versions.majorMinor version}/install-sh $out/share/icu/${lib.versions.majorMinor version}/mkinstalldirs # Avoid having a runtime dependency on bash

          substituteInPlace "$dev/bin/icu-config" \
            ${lib.concatMapStringsSep " " (r: "--replace '${r.from}' '${r.to}'") replacements}
        ''
      );

    postFixup = ''moveToOutput lib/icu "$dev" '';
  };

  buildRootOnlyAttrs = baseAttrs // {
    pname = pname + "-build-root";
    inherit version;

    preConfigure = baseAttrs.preConfigure + ''
      mkdir build
      cd build
      configureScript=../configure
    '';

    postBuild = ''
      cd ..
      mv build $out
      echo "Doing build-root only, exiting now" >&2
      exit 0
    '';
  };

  mkWithAttrs =
    attrs:
    stdenv.mkDerivation (
      finalAttrs:
      attrs
      // {
        passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
        passthru.buildRootOnly = mkWithAttrs buildRootOnlyAttrs;
      }
    );
in
mkWithAttrs realAttrs
