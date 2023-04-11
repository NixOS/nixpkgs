{ buildPythonPackage
, cirq-core
, requests
, pytestCheckHook
, pythonRelaxDepsHook
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

  sourceRoot = "source/${pname}";

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  postPatch = ''
    # Remove outdated test
    rm cirq_rigetti/service_test.py
  '';

  pythonRelaxDeps = [
    "attrs"
    "certifi"
    "h11"
    "httpcore"
    "httpx"
    "idna"
    "pyjwt"
    "qcs-api-client"
    "iso8601"
    "rfc3986"
    "pyquil"
    "pydantic"
  ];

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
