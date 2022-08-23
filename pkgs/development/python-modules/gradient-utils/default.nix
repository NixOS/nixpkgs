{ lib
, buildPythonPackage
, fetchFromGitHub
, hyperopt
, mock
, numpy
, poetry-core
, prometheus-client
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "gradient-utils";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Paperspace";
    repo = pname;
    rev = "v${version}";
    sha256 = "19plkgwwfs6298vjplgsvhirixi3jbngq5y07x9c0fjxk39fa2dk";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    hyperopt
    prometheus-client
    numpy
  ];

  checkInputs = [
    mock
    requests
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'wheel = "^0.35.1"' 'wheel = "*"' \
      --replace 'prometheus-client = ">=0.8,<0.10"' 'prometheus-client = "*"'
  '';

  preCheck = ''
    export HOSTNAME=myhost-experimentId
  '';

  disabledTestPaths = [
    # Requires a working Prometheus push gateway
    "tests/integration/test_metrics.py"
  ];

  pythonImportsCheck = [
    "gradient_utils"
  ];

  meta = with lib; {
    description = "Python utils and helpers library for Gradient";
    homepage = "https://github.com/Paperspace/gradient-utils";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
