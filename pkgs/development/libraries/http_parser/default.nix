{ stdenv, fetchurl, gyp, utillinux, python }:

let
  version = "2.1";
in stdenv.mkDerivation {
  name = "http-parser-${version}";

  src = fetchurl {
    url = "https://github.com/joyent/http-parser/archive/v${version}.tar.gz";
    sha256 = "16a2w5z4g2bma25fqcrkpidqzlq8a2jxkk93ajl721q85406j105";
  };

  patches = [ ./build-shared.patch ];

  configurePhase = "gyp -f make --depth=`pwd` http_parser.gyp";

  buildFlags = [ "BUILDTYPE=Release" ];

  buildInputs = [ gyp ] ++ (stdenv.lib.optional stdenv.isLinux utillinux) ++ stdenv.lib.optional stdenv.isDarwin python;

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    out/Release/test-nonstrict
    out/Release/test-strict
  '';

  installPhase = ''
    mkdir -p $out/lib
    mv out/Release/${if stdenv.isDarwin then "*.dylib" else "lib.target/*"} $out/lib

    mkdir -p $out/include
    mv http_parser.h $out/include
  '';

  postFixup = if stdenv.isDarwin then ''
    install_name_tool -id $out/lib/libhttp_parser.dylib $out/lib/libhttp_parser.dylib
    install_name_tool -id $out/lib/libhttp_parser_strict.dylib $out/lib/libhttp_parser_strict.dylib
  '' else null;

  meta = {
    description = "An HTTP message parser written in C";

    homepage = https://github.com/joyent/http-parser;

    license = stdenv.lib.licenses.mit;

    maintainer = [ stdenv.lib.maintainers.shlevy ];
  };
}
