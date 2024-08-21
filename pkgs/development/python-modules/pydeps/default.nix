{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  stdlib-list,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
  toml,
}:

buildPythonPackage rec {
  pname = "pydeps";
  version = "1.12.20";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thebjorn";
    repo = "pydeps";
    rev = "refs/tags/v${version}";
    hash = "sha256-d6EeeNem+HfuipKF5ZOI48c11j0ozGrBP4XlqTx+fJ4=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ graphviz ];

  propagatedBuildInputs = [
    graphviz
    stdlib-list
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    toml
  ];

  postPatch = ''
    # Path is hard-coded
    substituteInPlace pydeps/dot.py \
      --replace "dot -Gstart=1" "${lib.makeBinPath [ graphviz ]}/dot -Gstart=1"
  '';

  disabledTests = [
    # Would require to have additional modules available
    "test_find_package_names"
  ];

  pythonImportsCheck = [ "pydeps" ];

  meta = with lib; {
    description = "Python module dependency visualization";
    mainProgram = "pydeps";
    homepage = "https://github.com/thebjorn/pydeps";
    changelog = "https://github.com/thebjorn/pydeps/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
