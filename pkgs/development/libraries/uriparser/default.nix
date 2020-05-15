{ lib, stdenv, fetchurl, fetchpatch, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "uriparser";
  version = "0.9.3";

  # Release tarball differs from source tarball
  src = fetchurl {
    url = "https://github.com/uriparser/uriparser/releases/download/${pname}-${version}/${pname}-${version}.tar.bz2";
    sha256 = "13z234jdaqs9jj7i66gcv4q1rgsypjz6cighnlm1j4g80pdlmbr8";
  };

  patches = [
    # fixes tests
    (fetchpatch {
      url = "https://github.com/uriparser/uriparser/commit/f870e6c68696a6018702caa5c8a2feba9b0f99fa.diff";
      sha256 = "1nd6bhys9hwy6ippa42vm95zhw6hldm1s4xbdzmdjswc96as1ff5";
    })
  ];

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
