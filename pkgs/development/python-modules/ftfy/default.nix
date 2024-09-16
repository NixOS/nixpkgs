{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  wcwidth,

  # tests
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ftfy";
  version = "6.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ebUFmI8p1XelipBpr+dVU6AqRuQt5gkcBmDNxngSutw=";
  };

  build-system = [ poetry-core ];

  dependencies = [ wcwidth ];

  pythonImportsCheck = [ "ftfy" ];

  nativeCheckInputs = [
    versionCheckHook
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTestPaths = [
    # Calls poetry and fails to match output exactly
    "tests/test_cli.py"
  ];

  meta = with lib; {
    description = "Given Unicode text, make its representation consistent and possibly less broken";
    mainProgram = "ftfy";
    homepage = "https://github.com/LuminosoInsight/python-ftfy";
    license = licenses.asl20;
    maintainers = with maintainers; [ aborsu ];
  };
}
