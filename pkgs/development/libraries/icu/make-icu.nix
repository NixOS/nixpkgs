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
  #release = lib.replaceStrings [ "." ] [ "-" ] (if lib.hasSuffix "rc" version then lib.replaceStrings [ "1" ] [ "" ] version else version);

  baseAttrs = {
    src = fetchurl {
      url = "https://github.com/unicode-org/icu/releases/download/release-${release}/icu4c-${
        lib.replaceStrings [ "." ] [ "_" ] version
      }-src.tgz";
      inherit hash;
    };

    postUnpack = ''
      sourceRoot=''${sourceRoot}/source
      echo Source root reset to ''${sourceRoot}
    '';

    # https://sourceware.org/glibc/wiki/Release/2.26#Removal_of_.27xlocale.h.27
    postPatch =
      if
        (stdenv.hostPlatform.libc == "glibc" || stdenv.hostPlatform.libc == "musl")
        && lib.versionOlder version "62.1"
      then
        "substituteInPlace i18n/digitlst.cpp --replace '<xlocale.h>' '<locale.h>'"
      else
        null; # won't find locale_t on darwin

    inherit patchFlags patches;

    preConfigure =
      ''
        sed -i -e "s|/bin/sh|${stdenv.shell}|" configure

        # $(includedir) is different from $(prefix)/include due to multiple outputs
        sed -i -e 's|^\(CPPFLAGS = .*\) -I\$(prefix)/include|\1 -I$(includedir)|' config/Makefile.inc.in
      ''
      + lib.optionalString stdenv.hostPlatform.isAarch32 ''
        # From https://archlinuxarm.org/packages/armv7h/icu/files/icudata-stdlibs.patch
        sed -e 's/LDFLAGSICUDT=-nodefaultlibs -nostdlib/LDFLAGSICUDT=/' -i config/mh-linux
      '';

    dontDisableStatic = withStatic;

    configureFlags =
      [ "--disable-debug" ]
      ++ lib.optional (stdenv.hostPlatform.isFreeBSD || stdenv.hostPlatform.isDarwin) "--enable-rpath"
      ++ lib.optional (
        stdenv.buildPlatform != stdenv.hostPlatform
      ) "--with-cross-build=${nativeBuildRoot}"
      ++ lib.optional withStatic "--enable-static";

    enableParallelBuilding = true;

    meta = with lib; {
      description = "Unicode and globalization support library";
      homepage = "https://icu.unicode.org/";
      maintainers = with maintainers; [ raskin ];
      pkgConfigModules = [
        "icu-i18n"
        "icu-io"
        "icu-uc"
      ];
      platforms = platforms.all;
    };
  };

  realAttrs = baseAttrs // {
    inherit pname version;

    outputs = [
      "out"
      "dev"
    ] ++ lib.optional withStatic "static";
    outputBin = "dev";

    nativeBuildInputs =
      [ updateAutotoolsGnuConfigScriptsHook ]
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

    preConfigure =
      baseAttrs.preConfigure
      + ''
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
