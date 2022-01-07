{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, python
, mock
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-console-scripts";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "caeaaaf57f3a99e4482127e8a18467a1cfd49c92f4b37e5578d0bc40bf1b3394";
  };
  postPatch = ''
    # setuptools-scm is pinned to <6 because it dropped Python 3.5
    # support.  That's not something that affects us.
    substituteInPlace setup.py --replace "'setuptools_scm<6'" "'setuptools_scm'"
    # Patch the shebang of a script generated during test.
    substituteInPlace tests/test_run_scripts.py --replace "#!/usr/bin/env python" "#!${python.interpreter}"
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  nativeBuildInputs = [ setuptools-scm ];

  checkInputs = [ mock pytestCheckHook ];

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
