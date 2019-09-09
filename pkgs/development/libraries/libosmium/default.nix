{ stdenv, fetchFromGitHub, cmake, protozero, expat, zlib, bzip2, boost }:

stdenv.mkDerivation rec {
  pname = "libosmium";
  version = "2.15.2";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    rev = "v${version}";
    sha256 = "1fh8wl4grs1c0g9whx90kd4jva3k9b6zbb1cl3isay489gwndgss";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ protozero zlib bzip2 expat boost ];


  meta = with stdenv.lib; {
    description = "Fast and flexible C++ library for working with OpenStreetMap data";
    homepage = "https://osmcode.org/libosmium/";
    license = licenses.boost;
    maintainers = with maintainers; [ das-g ];
  };
}
