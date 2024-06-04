{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  decorator,
  ipython,
  isPyPy,
  exceptiongroup,
  tomli,
  setuptools,
  unittestCheckHook,
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

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://github.com/gotcha/ipdb";
    description = "IPython-enabled pdb";
    mainProgram = "ipdb3";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
