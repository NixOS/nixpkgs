{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cmake
, blas
}:

let
<<<<<<< HEAD
  suitesparseVersion = "7.1.0";
in
stdenv.mkDerivation {
  pname = "mongoose";
  version = "3.0.5";
=======
  suitesparseVersion = "7.0.1";
in
stdenv.mkDerivation rec {
  pname = "mongoose";
  version = "3.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "bin" "out" "dev" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    rev = "v${suitesparseVersion}";
<<<<<<< HEAD
    hash = "sha256-UizybioU1J01PLBpu+PfnSzWScGTvMuJN5j9PjuZRwE=";
=======
    hash = "sha256-EIreweeOx44YDxlnxnJ7l31Ie1jSx6y87VAyEX+4NsQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    blas
  ];

  dontUseCmakeConfigure = true;

  cmakeFlags = [
    "-DBLAS_LIBRARIES=${blas}"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  buildPhase = ''
    runHook preConfigure

    for f in SuiteSparse_config Mongoose; do
      (cd $f && cmakeConfigurePhase && make -j$NIX_BUILD_CORES)
    done

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    for f in SuiteSparse_config Mongoose; do
      (cd $f/build && make install -j$NIX_BUILD_CORES)
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Graph Coarsening and Partitioning Library";
    homepage = "https://github.com/DrTimothyAldenDavis/SuiteSparse/tree/dev/Mongoose";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wegank ];
    platforms = with platforms; unix;
  };
}
