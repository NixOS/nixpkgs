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
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-1QaMACLqTWC74V7l2LHLUMN/s/N4kNrE7+Ny1wkbavs=";
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
