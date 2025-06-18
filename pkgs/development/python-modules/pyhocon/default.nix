{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pyparsing,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyhocon";
  version = "0.3.61";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "chimpler";
    repo = "pyhocon";
    tag = version;
    hash = "sha256-xXx30uxJ8+KPVdYC6yRzEDJbwYSzIO/Gy1xrehvI5ZE=";
  };

  propagatedBuildInputs = [
    pyparsing
    python-dateutil
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyparsing~=2.0" "pyparsing>=2.0"
  '';

  pythonImportsCheck = [ "pyhocon" ];

  disabledTestPaths = [
    # pyparsing.exceptions.ParseException: Expected end of text, found '='
    # https://github.com/chimpler/pyhocon/issues/273
    "tests/test_tool.py"
  ];

  disabledTests = [
    # AssertionError: assert ConfigTree([(...
    "test_dict_merge"
    "test_parse_override"
    "test_include_dict"
  ];

  meta = with lib; {
    description = "HOCON parser for Python";
    mainProgram = "pyhocon";
    homepage = "https://github.com/chimpler/pyhocon/";
    longDescription = ''
      A HOCON parser for Python. It additionally provides a tool (pyhocon) to convert
      any HOCON content into JSON, YAML and properties format.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ chreekat ];
  };
}
