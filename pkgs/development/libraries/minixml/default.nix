{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mxml";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${version}";
    sha256 = "0madp2v2md3xq96aham91byns6qy4byd5pbg28q827fdahfhpmq7";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A small XML library";
    homepage = https://www.msweet.org/mxml/;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
