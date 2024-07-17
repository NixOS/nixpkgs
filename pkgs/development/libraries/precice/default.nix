{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gcc,
  boost,
  eigen,
  libxml2,
  mpi,
  python3,
  petsc,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "precice";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "precice";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RuZ18BFdusMHC+Yuapc2N8cEetLu32e28J34HH+gHOg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/precice/precice/commit/9dffe04144ab0f6a92fbff9be91cda71718b9c8e.patch";
      hash = "sha256-kSvIfBQH1mBA5CFJo9Usiypol0u9VgHMlUEHK/uHVNQ=";
    })
  ];

  cmakeFlags = [
    "-DPRECICE_PETScMapping=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DPYTHON_LIBRARIES=${python3.libPrefix}"
    "-DPYTHON_INCLUDE_DIR=${python3}/include/${python3.libPrefix}"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.isDarwin [ "-D_GNU_SOURCE" ]
    # libxml2-2.12 changed const qualifiers
    ++ [ "-fpermissive" ]
  );

  nativeBuildInputs = [
    cmake
    gcc
    pkg-config
    python3
    python3.pkgs.numpy
  ];
  buildInputs = [
    boost
    eigen
    libxml2
    mpi
    petsc
  ];

  meta = {
    description = "preCICE stands for Precise Code Interaction Coupling Environment";
    homepage = "https://precice.org/";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ Scriptkiddi ];
    mainProgram = "binprecice";
    platforms = lib.platforms.unix;
  };
}
