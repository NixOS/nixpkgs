{ lib, stdenv, fetchurl, fetchpatch, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "uriparser";
  version = "0.9.4";

  # Release tarball differs from source tarball
  src = fetchurl {
    url = "https://github.com/uriparser/uriparser/releases/download/${pname}-${version}/${pname}-${version}.tar.bz2";
    sha256 = "0yzqp1j6sglyrmwcasgn7zlwg841p3nbxy0h78ngq20lc7jspkdp";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DURIPARSER_BUILD_DOCS=OFF"
  ];

  checkInputs = [ gtest ];
  doCheck = stdenv.targetPlatform.system == stdenv.hostPlatform.system;

  meta = with stdenv.lib; {
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
