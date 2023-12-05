{ lib, stdenv, fetchurl, expat, zlib, boost, libiconv, darwin }:

stdenv.mkDerivation rec {
  pname = "exempi";
  version = "2.6.4";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/${pname}-${version}.tar.bz2";
    sha256 = "sha256-p1FJyWth45zcsEb9XlbYjP7qtuCPiU4V6//ZlECSv9A=";
  };

  configureFlags = [
    "--with-boost=${boost.dev}"
  ] ++ lib.optionals (!doCheck) [
    "--enable-unittest=no"
  ];

  buildInputs = [ expat zlib boost ]
    ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.CoreServices ];

  doCheck = stdenv.isLinux && stdenv.is64bit;
  dontDisableStatic = doCheck;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An implementation of XMP (Adobe's Extensible Metadata Platform)";
    homepage = "https://libopenraw.freedesktop.org/exempi/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
  };
}
