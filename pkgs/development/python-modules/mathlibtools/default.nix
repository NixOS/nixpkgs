{ lib
, atomicwrites
, buildPythonPackage
, click
, fetchPypi
, GitPython
, networkx
, pydot
, PyGithub
, pythonOlder
, pyyaml
, toml
, tqdm
}:

buildPythonPackage rec {
  pname = "mathlibtools";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iBYSh5Y8MYqzjeNt70eURr40SSKh0x41plemeaaOfy8=";
  };

  propagatedBuildInputs = [
    atomicwrites
    click
    GitPython
    networkx
    pydot
    PyGithub
    pyyaml
    toml
    tqdm
  ];

  # Requires internet access
  doCheck = false;

  pythonImportsCheck = [
    "mathlibtools"
  ];

  meta = with lib; {
    description = "Supporting tool for Lean's mathlib";
    homepage = "https://github.com/leanprover-community/mathlib-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ gebner ];
  };
}
