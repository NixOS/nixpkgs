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
}:

buildPythonPackage rec {
  pname = "ftfy";
  version = "6.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XkIUPHAl75eUTKJhnWthsGGfxmVPmHcdOehiwUJMdcA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ wcwidth ];

  nativeCheckInputs = [ pytestCheckHook ];

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
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
