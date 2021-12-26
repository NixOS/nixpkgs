{ lib, stdenv, fetchurl, fetchpatch, expat, zlib, boost, libiconv, darwin }:

stdenv.mkDerivation rec {
  pname = "exempi";
  version = "2.5.2";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/${pname}-${version}.tar.bz2";
    sha256 = "1mdfxb36p8251n5m7l55gx3fcqpk46yz9v568xfr8igxmqa47xaj";
  };

  configureFlags = [
    "--with-boost=${boost.dev}"
  ] ++ lib.optionals (!doCheck) [
    "--enable-unittest=no"
  ];

  buildInputs = [ expat zlib boost ]
    ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.CoreServices ];

  doCheck = stdenv.isLinux && stdenv.is64bit;
  # Tests rely on -static flag to pull in internal implementation for tests.
  dontDisableStatic = doCheck;

  meta = with lib; {
    description = "An implementation of XMP (Adobe's Extensible Metadata Platform)";
    homepage = "https://libopenraw.freedesktop.org/wiki/Exempi/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
  };
}
