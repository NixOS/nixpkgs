{ stdenv, fetchurl, python2Packages, utillinux, fixDarwinDylibNames }:

let
  version = "2.8.1";
in stdenv.mkDerivation {
  name = "http-parser-${version}";

  src = fetchurl {
    url = "https://github.com/joyent/http-parser/archive/v${version}.tar.gz";
    sha256 = "15ids8k2f0xhnnxh4m85w2f78pg5ndiwrpl24kyssznnp1l5yqai";
  };

  patches = [ ./build-shared.patch ];

  configurePhase = "gyp -f make --depth=`pwd` http_parser.gyp";

  buildFlags = [ "BUILDTYPE=Release" ];

  buildInputs =
    [ python2Packages.gyp ]
    ++ stdenv.lib.optional stdenv.isLinux utillinux
    ++ stdenv.lib.optionals stdenv.isDarwin [ python2Packages.python fixDarwinDylibNames ];

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

  meta = {
    description = "An HTTP message parser written in C";

    homepage = https://github.com/joyent/http-parser;

    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };
}
