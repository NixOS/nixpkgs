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
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HwtmrDGInCI5Hl+qhl+7hOBJ3Ux0g8IjoAVa4iAccl8=";
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
    changelog = "https://github.com/leanprover-community/mathlib-tools/raw/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ gebner ];
  };
}
