{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-nextbusnext";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ViViDboarder";
    repo = "py_nextbus";
    tag = "v${version}";
    hash = "sha256-zTOP2wj1ZseXYbWGNgehIkgZQkV4u74yjI0mhn35e4E=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "py_nextbus" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests access the internet
    "acceptance/client_test.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/ViViDboarder/py_nextbusnext/releases/tag/${src.tag}";
    description = "Minimalistic Python client for the NextBus public API";
    homepage = "https://github.com/ViViDboarder/py_nextbus";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
