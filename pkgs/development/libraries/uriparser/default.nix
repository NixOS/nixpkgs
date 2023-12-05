{ lib, stdenv, fetchurl, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "uriparser";
  version = "0.9.7";

  # Release tarball differs from source tarball
  src = fetchurl {
    url = "https://github.com/uriparser/uriparser/releases/download/${pname}-${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-0n3qDItvb7l5jwfK7e8c2WpuP8XGGJWWd04Zr6fd3tc=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DURIPARSER_BUILD_DOCS=OFF"
  ] ++ lib.optional (!doCheck) "-DURIPARSER_BUILD_TESTS=OFF";

  nativeCheckInputs = [ gtest ];
  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  meta = with lib; {
    description = "Strictly RFC 3986 compliant URI parsing library";
    longDescription = ''
      uriparser is a strictly RFC 3986 compliant URI parsing and handling library written in C.
      API documentation is available on uriparser website.
    '';
    homepage = "https://uriparser.github.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bosu ];
    mainProgram = "uriparse";
    platforms = platforms.unix;
  };
}
