{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, httpx
, protobuf
, pytest-asyncio
, pytest-httpx
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools-scm
, zeroconf
}:

buildPythonPackage rec {
  pname = "devolo-plc-api";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_plc_api";
    rev = "v${version}";
    sha256 = "sha256-FBcDEEWgfV+OgHriSOZKWZPt0O89nDe2CsY3oqX/6zo=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    httpx
    protobuf
    zeroconf
  ];

  checkInputs = [
    pytest-asyncio
    pytest-httpx
    pytest-mock
    pytestCheckHook
  ];



  pythonImportsCheck = [
    "devolo_plc_api"
  ];

  meta = with lib; {
    description = "Python module to interact with Devolo PLC devices";
    homepage = "https://github.com/2Fake/devolo_plc_api";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
