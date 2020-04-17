{ stdenv, fetchurl, pkgconfig, cmake, perl }:

with stdenv.lib;
stdenv.mkDerivation rec{

  pname = "libtap";
  version = "1.14.0";

  src = fetchurl {
    url = "https://web-cpan.shlomifish.org/downloads/${pname}-${version}.tar.xz";
    sha256 = "1ga7rqmppa8ady665736cx443icscqlgflkqmxd4xbkzypmdj9bk";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ cmake perl ];

  meta = with stdenv.lib; {
    description = "A library to implement a test protocol";
    longDescription = ''
      libtap is a library to implement the Test Anything Protocol for
      C originally created by Nik Clayton. This is a maintenance
      branch by Shlomi Fish.
    '';
    homepage = "https://www.shlomifish.org/open-source/projects/libtap/";
    license = licenses.bsd3;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
