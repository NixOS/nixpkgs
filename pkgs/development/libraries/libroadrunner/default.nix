{ lib, stdenv, callPackage, fetchFromGitHub, cmake, gcc, boost, eigen, libxml2, mpi, python3, petsc, llvm_13, swig4 }:

let
  pythonDeps = with python3.pkgs; [
    numpy
    matplotlib
  ];

  roadrunner-deps = callPackage ./roadrunner-deps.nix { };

  version = "2.2.0";

  roadrunner = stdenv.mkDerivation rec {
    inherit version;
    pname = "roadrunner";

    src = fetchFromGitHub {
      owner = "sys-bio";
      repo = pname;
      rev = "v${version}";
      sha256 = "0y7r0f1fm6xw57yf9wximw7vll1bpr7fsx477kraabskvqyfpg7r";
    };

    buildPhase = ''
      substituteInPlace requirements.txt --replace 'numpy>=1.21.0;python_version<="3.7"' 'numpy>=1.21.0;python_version<="3.9"'
      export LD_LIBRARY_PATH=$PWD/lib
    '';

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DBUILD_RR_PLUGINS=ON"
      "-DRR_DEPENDENCIES_INSTALL_PREFIX=${roadrunner-deps}"
      "-DLLVM_INSTALL_PREFIX=${llvm_13}"
      "-DBUILD_TESTS=ON"
      "-DBUILD_PYTHON=ON"
      "-DSWIG_EXECUTABLE=${swig4}/bin/swig"
      "-DPython_ROOT_DIR=${python3}"
      "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    ];


    nativeBuildInputs = [ cmake ] ++ pythonDeps;
    buildInputs = [ boost eigen libxml2 mpi python3 python3.pkgs.numpy roadrunner-deps llvm_13 swig4 ];

    meta = {
      description = "A high performance and portable simulation engine for systems and synthetic biology.";
      license = with lib.licenses; [ asl20 ];
      homepage = "https://libroadrunner.org/";
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ Scriptkiddi ];
    };
  };


  roadrunner-python = python3.pkgs.buildPythonPackage rec {
    pname = "roadrunner-python";
    inherit version;
    src = "${roadrunner.out}";
    pythonImportsCheck = [ "roadrunner" ];

    propagatedBuildInputs = pythonDeps;
  };
in roadrunner // { passthru.python = roadrunner-python; }

