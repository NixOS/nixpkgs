{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  pythonOlder,
  decorator,
  ipython,
  isPyPy,
  exceptiongroup,
  tomli,
  setuptools,
  pytestCheckHook,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.13.13";
  format = "pyproject";

  disabled = isPyPy; # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-46xgGO8FEm1EKvaAqthjAG7BnQIpBWGsiLixwLDPxyY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs =
    [
      ipython
      decorator
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      exceptiongroup
      tomli
    ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths =
    [
      # OSError: pytest: reading from stdin while output is captured!  Consider using `-s`.
      "manual_test.py"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # tests get stuck
      "tests/test_opts.py"
    ];

  meta = with lib; {
    homepage = "https://github.com/gotcha/ipdb";
    description = "IPython-enabled pdb";
    mainProgram = "ipdb3";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
