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
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "thebjorn";
    repo = "pydeps";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZLFcaWzu8iYBnbSh1Ua4fvFyYD5q71R/iIqzRUKRn1E=";
  };

  build-system = [ setuptools ];

  buildInputs = [ graphviz ];

  dependencies = [
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
    homepage = "https://github.com/thebjorn/pydeps";
    changelog = "https://github.com/thebjorn/pydeps/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pydeps";
  };
}
