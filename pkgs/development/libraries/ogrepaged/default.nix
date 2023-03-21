{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, ogre
}:

stdenv.mkDerivation rec {
  pname = "ogre-paged";
  version = "unstable-2020-01-28";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "ogre-pagedgeometry";
    rev = "9b4ee07dd7a884c667fc4051523b26b746bbd2c7";
    sha256 = "sha256-9LkZVQXgEzfjQS1rclWtyNzJAgRLyaXZmzlWclF62lk=";
  };

  postPatch = ''
    sed -i '/libdir/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ogre
  ];

  meta = {
    description = "Paged Geometry for Ogre3D";
    homepage = "https://github.com/RigsOfRods/ogre-paged";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
