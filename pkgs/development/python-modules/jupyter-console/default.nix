{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  ipykernel,
  exceptiongroup,
  ipython,
  jupyter-client,
  jupyter-core,
  prompt-toolkit,
  pygments,
  pyzmq,
  traitlets,
  flaky,
  pexpect,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jupyter-console";
  version = "6.6.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "jupyter_console";
    inherit version;
    hash = "sha256-VmpL8xyHrb+t8izfhG4wabWace1dpx1rpNiqrRSlNTk=";
  };

  nativeBuildInputs = [ hatchling ];

  postPatch = ''
    # use wrapped executable in tests
    substituteInPlace jupyter_console/tests/test_console.py \
      --replace "args = ['-m', 'jupyter_console', '--colors=NoColor']" "args = ['--colors=NoColor']" \
      --replace "cmd = sys.executable" "cmd = '${placeholder "out"}/bin/jupyter-console'" \
      --replace "check_output([sys.executable, '-m', 'jupyter_console'," "check_output(['${placeholder "out"}/bin/jupyter-console',"
  '';

  propagatedBuildInputs = [
    ipykernel
    ipython
    jupyter-client
    jupyter-core
    prompt-toolkit
    pygments
    pyzmq
    traitlets
  ] ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ];

  pythonImportsCheck = [ "jupyter_console" ];

  nativeCheckInputs = [
    flaky
    pexpect
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "Jupyter terminal console";
    mainProgram = "jupyter-console";
    homepage = "https://github.com/jupyter/jupyter_console";
    changelog = "https://github.com/jupyter/jupyter_console/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
  };
}
