{ buildPythonPackage
, cirq-core
, requests
, pytestCheckHook
, attrs
, certifi
, h11
, httpcore
, idna
, httpx
, iso8601
, pydantic
, pyjwt
, pyquil
, python-dateutil
, pythonOlder
, qcs-api-client
, retrying
, rfc3339
, rfc3986
, six
, sniffio
, toml
}:

buildPythonPackage rec {
  pname = "cirq-rigetti";
  inherit (cirq-core) version src meta;

  disabled = pythonOlder "3.7";

  sourceRoot = "${src.name}/${pname}";

  pythonRelaxDeps = [
    "attrs"
    "certifi"
    "h11"
    "httpcore"
    "httpx"
    "idna"
    "iso8601"
    "pydantic"
    "pyjwt"
    "pyquil"
    "qcs-api-client"
    "rfc3986"
  ];

  postPatch = ''
    # Remove outdated test
    rm cirq_rigetti/service_test.py
  '';

  propagatedBuildInputs = [
    cirq-core
    attrs
    certifi
    h11
    httpcore
    httpx
    idna
    iso8601
    pydantic
    pyjwt
    pyquil
    python-dateutil
    qcs-api-client
    retrying
    rfc3339
    rfc3986
    six
    sniffio
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_rigetti/_version_test.py"
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_rigetti" ];
}
