{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hyperopt,
  mock,
  numpy,
  poetry-core,
  prometheus-client,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "gradient-utils";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Paperspace";
    repo = "gradient-utils";
    tag = "v${version}";
    hash = "sha256-swnl0phdOsBSP8AX/OySI/aYI9z60Ss3SsJox/mb9KY=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    hyperopt
    prometheus-client
    numpy
  ];

  nativeCheckInputs = [
    mock
    requests
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/Paperspace/gradient-utils/issues/68
    # https://github.com/Paperspace/gradient-utils/issues/72
    substituteInPlace pyproject.toml \
      --replace 'wheel = "^0.35.1"' 'wheel = "*"' \
      --replace 'prometheus-client = ">=0.8,<0.10"' 'prometheus-client = "*"' \
      --replace 'pymongo = "^3.11.0"' 'pymongo = ">=3.11.0"'
  '';

  preCheck = ''
    export HOSTNAME=myhost-experimentId
  '';

  disabledTestPaths = [
    # Requires a working Prometheus push gateway
    "tests/integration/test_metrics.py"
  ];

  pythonImportsCheck = [ "gradient_utils" ];

  meta = with lib; {
    description = "Python utils and helpers library for Gradient";
    homepage = "https://github.com/Paperspace/gradient-utils";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
