{ stdenv, fetchurl, fetchpatch, fixDarwinDylibNames }:

let
  pname = "icu4c";
  version = "57.1";
in
stdenv.mkDerivation ({
  name = pname + "-" + version;

  src = fetchurl {
    url = "http://download.icu-project.org/files/${pname}/${version}/${pname}-"
      + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.tgz";
    sha256 = "10cmkqigxh9f73y7q3p991q6j8pph0mrydgj11w1x6wlcp5ng37z";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  # FIXME: This fixes dylib references in the dylibs themselves, but
  # not in the programs in $out/bin.
  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  postUnpack = ''
    sourceRoot=''${sourceRoot}/source
    echo Source root reset to ''${sourceRoot}
  '';

  # This pre/postPatch shenanigans is to handle that the patches expect
  # to be outside of `source`.
  prePatch = ''
    pushd ..
  '';
  postPatch = ''
    popd
  '';

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/i/icu/57.1-5/debian/patches/CVE-2014-6585.patch";
      sha256 = "1s8kqax444pqf5chwxvgsx1n1dx7v74h34fqh08fyq57mcjnpj4d";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/i/icu/57.1-5/debian/patches/CVE-2015-4760.patch";
      sha256 = "08gawyqbylk28i9pxv9vsw2drdpd6i97q0aml4nmv2xyb1ala0wp";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/i/icu/57.1-5/debian/patches/CVE-2016-0494.patch";
      sha256 = "1741s8lpmnizjprzk3xb7zkm5fznzgk8hhlrs8a338c18nalvxay";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/i/icu/57.1-5/debian/patches/CVE-2016-6293.patch";
      sha256 = "01h4xcss1vmsr60ijkv4lxsgvspwimyss61zp9nq4xd5i3kk1f4b";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/i/icu/57.1-5/debian/patches/CVE-2016-7415.patch";
      sha256 = "01d070h8d7rkj55ac8isr64m999bv5znc8vnxa7aajglsfidzs2r";
    })
  ];

  preConfigure = ''
    sed -i -e "s|/bin/sh|${stdenv.shell}|" configure
  '';

  configureFlags = "--disable-debug" +
    stdenv.lib.optionalString (stdenv.isFreeBSD || stdenv.isDarwin) " --enable-rpath";

  # remove dependency on bootstrap-tools in early stdenv build
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/INSTALL_CMD=.*install/INSTALL_CMD=install/' $out/lib/icu/${version}/pkgdata.inc
  '';

  postFixup = ''moveToOutput lib/icu "$dev" '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Unicode and globalization support library";
    homepage = http://site.icu-project.org/;
    maintainers = with maintainers; [ raskin urkud ];
    platforms = platforms.all;
  };
} // (if stdenv.isArm then {
  patches = [ ./0001-Disable-LDFLAGSICUDT-for-Linux.patch ];
} else {}))
