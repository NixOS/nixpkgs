{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, python
, mock
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-console-scripts";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XGw9qunPn77Q5lUHISiThgAZPcACpc8bGHJIZEugKFc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    # Patch the shebang of a script generated during test.
    substituteInPlace tests/test_run_scripts.py \
      --replace "#!/usr/bin/env python" "#!${python.interpreter}"
  '';

  pythonImportsCheck = [
    "pytest_console_scripts"
  ];

  meta = with lib; {
    description = "Pytest plugin for testing console scripts";
    longDescription = ''
      Pytest-console-scripts is a pytest plugin for running python scripts from within tests.
      It's quite similar to subprocess.run(), but it also has an in-process mode, where the scripts are executed by the interpreter that's running pytest (using some amount of sandboxing).
    '';
    homepage = "https://github.com/kvas-it/pytest-console-scripts";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
