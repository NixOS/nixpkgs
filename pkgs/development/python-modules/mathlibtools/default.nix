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
  version = "1.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jbnb3FKyB1NAehB8tZxBV6d7JJCOgWZPMWMaFEAOzkM=";
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
