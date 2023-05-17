{ lib, stdenv, fetchFromGitHub, cmake, openexr, boost, jemalloc, c-blosc, ilmbase, tbb }:

stdenv.mkDerivation rec
{
  pname = "openvdb";
  version = "10.0.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openvdb";
    rev = "v${version}";
    sha256 = "sha256-kaf5gpGYVWinmnRwR/IafE1SJcwmP2psfe/UZdtH1Og=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openexr boost tbb jemalloc c-blosc ilmbase ];

  cmakeFlags = [ "-DOPENVDB_CORE_STATIC=OFF" ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenVDB/FindOpenVDB.cmake \
      --replace \''${OPENVDB_LIBRARYDIR} $out/lib \
      --replace \''${OPENVDB_INCLUDEDIR} $dev/include
  '';

  meta = with lib; {
    description = "An open framework for voxel";
    homepage = "https://www.openvdb.org";
    maintainers = [ maintainers.guibou ];
    platforms = platforms.unix;
    license = licenses.mpl20;
  };
}
