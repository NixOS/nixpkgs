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

  sourceRoot = "source/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "attrs~=20.3.0" "attrs" \
      --replace "certifi~=2021.5.30" "certifi" \
      --replace "h11~=0.9.0" "h11" \
      --replace "httpcore~=0.11.1" "httpcore" \
      --replace "httpx~=0.15.5" "httpx" \
      --replace "idna~=2.10" "idna" \
      --replace "pyjwt~=1.7.1" "pyjwt" \
      --replace "qcs-api-client~=0.8.0" "qcs-api-client" \
      --replace "iso8601~=0.1.14" "iso8601" \
      --replace "rfc3986~=1.5.0" "rfc3986" \
      --replace "pyquil~=3.0.0" "pyquil" \
      --replace "pydantic~=1.8.2" "pydantic"
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
