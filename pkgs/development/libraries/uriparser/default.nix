{ stdenv, fetchurl, cpptest, pkgconfig, doxygen, graphviz }:

stdenv.mkDerivation rec {
  name = "uriparser-${version}";
  version = "0.8.6";

  # Release tarball differs from source tarball
  src = fetchurl {
    url = "https://github.com/uriparser/uriparser/releases/download/${name}/${name}.tar.bz2";
    sha256 = "0m2a5bf5b00ybagxmsa8mdj9mhc62vcm0qimy1ivfza1fbjsf287";
  };

  nativeBuildInputs = [ pkgconfig cpptest doxygen graphviz ];

  doCheck = true;

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
