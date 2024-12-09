{
  lib,
  atomicwrites,
  buildPythonPackage,
  click,
  fetchPypi,
  gitpython,
  networkx,
  pydot,
  pygithub,
  pythonOlder,
  pyyaml,
  toml,
  tqdm,
}:

buildPythonPackage rec {
  pname = "mathlibtools";
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mkn0y3NV/acnkqVzi8xd+Sex4QLvxxmt++FtsZmgrGs=";
  };

  propagatedBuildInputs = [
    atomicwrites
    click
    gitpython
    networkx
    pydot
    pygithub
    pyyaml
    toml
    tqdm
  ];

  # Requires internet access
  doCheck = false;

  pythonImportsCheck = [ "mathlibtools" ];

  meta = with lib; {
    description = "Supporting tool for Lean's mathlib";
    mainProgram = "leanproject";
    homepage = "https://github.com/leanprover-community/mathlib-tools";
    changelog = "https://github.com/leanprover-community/mathlib-tools/raw/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ gebner ];
  };
}
