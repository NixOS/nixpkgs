{ lib, stdenv, fetchurl, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "uriparser";
  version = "0.9.5";

  # Release tarball differs from source tarball
  src = fetchurl {
    url = "https://github.com/uriparser/uriparser/releases/download/${pname}-${version}/${pname}-${version}.tar.bz2";
    sha256 = "0v30qr5hl3xybl9nzwaw46kblwn94w5xpri22wanrrpjlzmn306x";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DURIPARSER_BUILD_DOCS=OFF"
  ];

  checkInputs = [ gtest ];
  doCheck = stdenv.targetPlatform.system == stdenv.hostPlatform.system;

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
