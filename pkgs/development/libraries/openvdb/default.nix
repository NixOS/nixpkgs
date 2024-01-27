{ lib, stdenv, fetchFromGitHub, cmake, boost, jemalloc, c-blosc, tbb, zlib }:

stdenv.mkDerivation rec
{
  pname = "openvdb";
  version = "11.0.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openvdb";
    rev = "v${version}";
    sha256 = "sha256-wDDjX0nKZ4/DIbEX33PoxR43dJDj2NF3fm+Egug62GQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost tbb jemalloc c-blosc zlib ];

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
