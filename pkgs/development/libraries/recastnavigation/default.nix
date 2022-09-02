{ stdenv, lib, fetchFromGitHub, cmake, libGL, SDL2, libGLU, catch }:

stdenv.mkDerivation rec {
  pname = "recastai";
  # use latest revision for the CMake build process and OpenMW
  # OpenMW use e75adf86f91eb3082220085e42dda62679f9a3ea
  version = "unstable-2021-03-05";

  src = fetchFromGitHub {
    owner = "recastnavigation";
    repo = "recastnavigation";
    rev = "c5cbd53024c8a9d8d097a4371215e3342d2fdc87";
    sha256 = "sha256-QP3lMMFR6fiKQTksAkRL6X9yaoVz2xt4QSIP9g6piww=";
  };

  postPatch = ''
    cp ${catch}/include/catch/catch.hpp Tests/catch.hpp
  '';

  doCheck = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libGL SDL2 libGLU ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/recastnavigation/recastnavigation";
    description = "Navigation-mesh Toolset for Games";
    license = licenses.zlib;
    maintainers = with maintainers; [ marius851000 ];
    platforms = platforms.all;
  };
}
