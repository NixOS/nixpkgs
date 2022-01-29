{ lib, stdenv, fetchurl, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "uriparser";
  version = "0.9.6";

  # Release tarball differs from source tarball
  src = fetchurl {
    url = "https://github.com/uriparser/uriparser/releases/download/${pname}-${version}/${pname}-${version}.tar.bz2";
    sha256 = "9ce4c3f151e78579f23937b44abecb428126863ad02e594e115e882353de905b";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DURIPARSER_BUILD_DOCS=OFF"
  ] ++ lib.optional (!doCheck) "-DURIPARSER_BUILD_TESTS=OFF";

  checkInputs = [ gtest ];
  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  meta = with lib; {
    homepage = "https://uriparser.github.io/";
    description = "Strictly RFC 3986 compliant URI parsing library";
    longDescription = ''
      uriparser is a strictly RFC 3986 compliant URI parsing and handling library written in C.
      API documentation is available on uriparser website.
    '';
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bosu ];
  };
}
