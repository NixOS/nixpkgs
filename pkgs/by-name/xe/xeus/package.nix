{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
  nlohmann_json,
  libuuid,
  xtl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeus";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-YtAkegwHo9XXIz0l5qXqnKn6kP1MWETXbVommX+Pws8=";
  };

  nativeBuildInputs = [
    cmake
    doctest
  ];

  buildInputs = [
    nlohmann_json
    libuuid
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
})
