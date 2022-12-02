{ lib, stdenv, fetchFromGitHub, cmake, openexr, boost, jemalloc, c-blosc, ilmbase, tbb }:

stdenv.mkDerivation rec
{
  pname = "openvdb";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "dreamworksanimation";
    repo = "openvdb";
    rev = "v${version}";
    sha256 = "sha256-OP1xCR1YW60125mhhrW5+8/4uk+EBGIeoWGEU9OiIGY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openexr boost tbb jemalloc c-blosc ilmbase ];

  meta = with lib; {
    description = "An open framework for voxel";
    homepage = "https://www.openvdb.org";
    maintainers = [ maintainers.guibou ];
    platforms = platforms.unix;
    license = licenses.mpl20;
  };
}
