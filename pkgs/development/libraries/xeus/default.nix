{ lib
, stdenv
, fetchFromGitHub
, cmake
, doctest
, nlohmann_json
, libuuid
, xtl
}:

stdenv.mkDerivation rec {
  pname = "xeus";
<<<<<<< HEAD
  version = "3.1.1";
=======
  version = "3.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-jZZe8SegQuFLoH2Qp+etoKELGEWdlYQPXj14DNIMJ/0=";
=======
    sha256 = "sha256-LeU4PJ1UKfGqkRKq0/Mn9gjwNmXCy0/2SbjWJrjlOyU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    doctest
  ];

  buildInputs = [
    nlohmann_json
    libuuid
    xtl
  ];

  cmakeFlags = [
    "-DXEUS_BUILD_TESTS=ON"
  ];

  doCheck = true;
  preCheck = ''export LD_LIBRARY_PATH=$PWD'';

  meta = with lib; {
    homepage = "https://xeus.readthedocs.io";
    description = "C++ implementation of the Jupyter Kernel protocol";
    license = licenses.bsd3;
    maintainers = with maintainers; [ serge_sans_paille ];
    platforms = platforms.all;
  };
}
