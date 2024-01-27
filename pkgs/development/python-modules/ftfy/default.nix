{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, poetry-core

# dependencies
, wcwidth

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ftfy";
  version = "6.1.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aTJ0rq2BHP8kweh4QWWqdVzS9uRCpexTXH1pf2QipCI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    wcwidth
  ];

  nativeCheckInputs = [
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
    homepage = "https://github.com/LuminosoInsight/python-ftfy";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
