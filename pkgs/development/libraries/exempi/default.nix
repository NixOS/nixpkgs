{ lib, stdenv, fetchurl, expat, zlib, boost, libiconv, darwin }:

stdenv.mkDerivation rec {
  pname = "exempi";
  version = "2.6.3";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/${pname}-${version}.tar.bz2";
    sha256 = "sha256-sHSdsYqeeM93FzeVSoOM3NsdVBWIi6wbqcr4y6d8ZWw=";
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
