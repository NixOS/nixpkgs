{
  buildPythonPackage,
  cirq-core,
  fetchpatch2,
  lib,
  pytestCheckHook,
  attrs,
  certifi,
  h11,
  httpcore,
  idna,
  httpx,
  iso8601,
  pydantic,
  pyjwt,
  pyquil,
  python-dateutil,
  pythonOlder,
  qcs-api-client,
  retrying,
  rfc3339,
  rfc3986,
  six,
  sniffio,
  toml,
}:

buildPythonPackage rec {
  pname = "cirq-rigetti";
  format = "setuptools";
  inherit (cirq-core) version src;

  disabled = pythonOlder "3.7";

  patches = [
    # https://github.com/quantumlib/Cirq/pull/6734
    (fetchpatch2 {
      name = "fix-rigetti-check-for-aspen-family-device-kind.patch";
      url = "https://github.com/quantumlib/Cirq/commit/dd395fb71fb7f92cfd34f008bf2a98fc70b57fae.patch";
      stripLen = 1;
      hash = "sha256-EWB2CfMS2+M3zNFX5PwFNtEBdgJkNVUVNd+I/E6n9kI=";
    })
  ];

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

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_rigetti/_version_test.py"
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_rigetti" ];
}
