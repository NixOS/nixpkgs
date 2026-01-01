{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-bidi";
<<<<<<< HEAD
  version = "0.6.7";
=======
  version = "0.6.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MeirKriheli";
    repo = "python-bidi";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8LNoQwUOa2pKEviBq24IHihUfhyMoA/IV+sBuFUhHdc=";
=======
    hash = "sha256-8erpcrjAp/1ugPe6cOvjH2CVfy2/hO6xg+cfWWUbj0w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-27DtYoxd0bPS4A/7HBmuLYCZrG5yu0Tp8jXIBPSrAdc=";
=======
    hash = "sha256-Oqtva9cTHAcuOXr/uPbqZczDbPVr0zeIEr5p6PoJ610=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [ libiconv ];

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  preCheck = ''
    rm -rf bidi
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/MeirKriheli/python-bidi";
    description = "Pure python implementation of the BiDi layout algorithm";
    mainProgram = "pybidi";
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
