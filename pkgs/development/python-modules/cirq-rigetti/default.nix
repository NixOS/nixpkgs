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

  sourceRoot = "source/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "attrs~=20.3.0" "attrs" \
      --replace "certifi~=2021.5.30" "certifi" \
      --replace "h11~=0.9.0" "h11" \
      --replace "httpcore~=0.11.1" "httpcore" \
      --replace "httpx~=0.15.5" "httpx" \
      --replace "idna~=2.10" "idna" \
      --replace "requests~=2.18" "requests" \
      --replace "pyjwt~=1.7.1" "pyjwt" \
      --replace "qcs-api-client~=0.8.0" "qcs-api-client"
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

  checkInputs = [
    pytestCheckHook
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_rigetti" ];
}
