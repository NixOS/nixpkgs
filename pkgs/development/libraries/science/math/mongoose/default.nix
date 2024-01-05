{ lib
, stdenv
, fetchFromGitHub
, cmake
, blas
, llvmPackages
}:

let
  suitesparseVersion = "7.4.0";
in
stdenv.mkDerivation {
  pname = "mongoose";
  version = "3.3.0";

  outputs = [ "bin" "out" "dev" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    rev = "v${suitesparseVersion}";
    hash = "sha256-oR/lISsa+0NGueJJyutswxOEQVl8MmSVgb/q3GMUCn4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    blas
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
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
