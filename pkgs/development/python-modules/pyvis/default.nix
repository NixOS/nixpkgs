{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  networkx,
  jinja2,
  ipython,
  jsonpickle,
  pytestCheckHook,
  numpy,
}:

buildPythonPackage rec {
  pname = "pyvis";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WestHealth";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-eo9Mk2c0hrBarCrzwmkXha3Qt4Bl1qR7Lhl9EkUx96E=";
  };

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    jinja2
    networkx
    ipython
    jsonpickle
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  disabledTestPaths = [
    # jupyter integration test with selenium and webdriver_manager
    "pyvis/tests/test_html.py"
  ];

  pythonImportsCheck = [ "pyvis" ];

  meta = with lib; {
    homepage = "https://github.com/WestHealth/pyvis";
    description = "Python package for creating and visualizing interactive network graphs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pbsds ];
  };
}
