{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, ipykernel
, jupytext
, mkdocs
, mkdocs-material
, nbconvert
, pygments
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "mkdocs-jupyter";
<<<<<<< HEAD
  version = "0.24.2";
=======
  version = "0.24.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "mkdocs_jupyter";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-XgwQnVNdSHlyMHGbaUH00I3pWno8lb8VhmLEEvwVyy4=";
=======
    hash = "sha256-lncDf7fpMSaPPfdZn8CCjCYSR989FXW87TILqLfR1G0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
    substituteInPlace mkdocs_jupyter/tests/test_base_usage.py \
      --replace "[\"mkdocs\"," "[\"${mkdocs.out}/bin/mkdocs\","
  '';

  pythonRelaxDeps = [
    "nbconvert"
  ];

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    ipykernel
    jupytext
    mkdocs
    mkdocs-material
    nbconvert
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mkdocs_jupyter"
  ];

  meta = with lib; {
    description = "Use Jupyter Notebook in mkdocs";
    homepage = "https://github.com/danielfrg/mkdocs-jupyter";
    changelog = "https://github.com/danielfrg/mkdocs-jupyter/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ net-mist ];
  };
}
