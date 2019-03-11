{ lib, stdenv, fetchurl, gtest, pkgconfig, doxygen, graphviz }:

stdenv.mkDerivation rec {
  name = "uriparser-${version}";
  version = "0.9.1";

  # Release tarball differs from source tarball
  src = fetchurl {
    url = "https://github.com/uriparser/uriparser/releases/download/${name}/${name}.tar.bz2";
    sha256 = "1gisi7h8hd6mswbiaaa3s25bnb77xf37pzrmjy63rcdpwcyqy93m";
  };

  nativeBuildInputs = [ pkgconfig doxygen graphviz ];
  buildInputs = lib.optional doCheck gtest;
  configureFlags = lib.optional (!doCheck) "--disable-tests";

  doCheck = stdenv.targetPlatform.system == stdenv.hostPlatform.system;

  meta = with stdenv.lib; {
    homepage = https://uriparser.github.io/;
    description = "Strictly RFC 3986 compliant URI parsing library";
    longDescription = ''
      uriparser is a strictly RFC 3986 compliant URI parsing and handling library written in C.
      API documentation is available on uriparser website.
    '';
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bosu ];
  };
}
