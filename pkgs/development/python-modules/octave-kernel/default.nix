{
  lib,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  metakernel,
  jupyter-client,
  ipykernel,
  nbconvert,
  pytest,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "octave_kernel";
  version = "0.36.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Calysto";
    repo = "octave_kernel";
    rev = "refs/tags/v${version}";
    hash = "sha256-/EmKUWCqlFlpJugIx7PLL99KJ5Lhyb/ropmfe9Symlw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    metakernel
    jupyter-client
    ipykernel
  ];

  optional-dependencies = {
    test = [
      pytest
      nbconvert
    ];
  };

  meta = with lib; {
    description = "A Jupyter kernel for Octave.";
    license = licenses.bsd3;
    homepage = "https://github.com/Calysto/octave_kernel";
    maintainers = with maintainers; [ fred441a ];
  };

}
