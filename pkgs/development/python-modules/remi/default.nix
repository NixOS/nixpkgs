{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  matplotlib,
  python-snap7,
  opencv4,
}:

buildPythonPackage rec {
  pname = "remi";
  version = "2022.7.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rawpython";
    repo = "remi";
    rev = version;
    hash = "sha256-VQn+Uzp6oGSit8ot0e8B0C2N41Q8+J+o91skyVN1gDA=";
  };

  preCheck = ''
    # for some reason, REMI already deal with these using try blocks, but they fail
    substituteInPlace test/test_widget.py \
      --replace-fail \
        "from html_validator import " \
        "from .html_validator import "
    substituteInPlace test/test_examples_app.py \
      --replace-fail \
        "from mock_server_and_request import " \
        "from .mock_server_and_request import " \
      --replace-fail \
        "from html_validator import " \
        "from .html_validator import "
    # Halves number of warnings
    substituteInPlace test/test_*.py \
      --replace-quiet \
        "self.assertEquals(" \
        "self.assertEqual("
  '';

  build-system = [ setuptools ];

  dependencies = [
    setuptools # pkg_resources is referenced at runtime
  ];

  nativeCheckInputs = [
    pytestCheckHook
    python-snap7
    opencv4
    matplotlib
  ];

  pythonImportsCheck = [
    "remi"
    "editor"
    "editor.widgets"
  ];

  meta = {
    description = "Pythonic, lightweight and websocket-based webui library";
    homepage = "https://github.com/rawpython/remi";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
