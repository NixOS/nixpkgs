{ lib
, buildPythonPackage
, fetchFromGitHub
, hyperopt
, mock
, numpy
, poetry-core
, prometheus-client
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "gradient-utils";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Paperspace";
    repo = pname;
    rev = "v${version}";
    sha256 = "19plkgwwfs6298vjplgsvhirixi3jbngq5y07x9c0fjxk39fa2dk";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'numpy = "1.18.5"' 'numpy = "^1.18.5"' \
      --replace 'hyperopt = "0.1.2"' 'hyperopt = ">=0.1.2"' \
      --replace 'wheel = "^0.35.1"' 'wheel = "*"' \
      --replace 'prometheus-client = ">=0.8,<0.10"' 'prometheus-client = "*"'
  '';

  nativeBuildInputs = [ poetry-core ];

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

  preCheck = ''
    export HOSTNAME=myhost-experimentId
  '';

  disabledTests = [
    "test_add_metrics_pushes_metrics" # requires a working prometheus push gateway
  ];

  disabledTestPaths = [
    # needs network access
    "tests/integration/test_metrics.py"
  ];

  pythonImportsCheck = [ "gradient_utils" ];

  meta = with lib; {
    description = "Python utils and helpers library for Gradient";
    homepage = "https://github.com/Paperspace/gradient-utils";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
