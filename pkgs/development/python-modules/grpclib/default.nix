{ buildPythonPackage
, fetchFromGitHub
, lib
, pythonOlder
, h2
, multidict
, pytestCheckHook
, pytest-asyncio
, async-timeout
, faker
, googleapis-common-protos
, certifi
}:
let
  pname = "grpclib";
  version = "0.4.4";
in
buildPythonPackage {
  inherit pname version;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vmagamedov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bCLyBfsNdIGdpz9l/r2iYIQ5TitKmsctekeOthIkXhw=";
  };

  propagatedBuildInputs = [
    h2
    multidict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    async-timeout
    faker
    googleapis-common-protos
    certifi
  ];

  pythonImportsCheck = [ "grpclib" ];

  meta = with lib; {
    description = "Pure-Python gRPC implementation for asyncio";
    homepage = "https://github.com/vmagamedov/grpclib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nikstur ];
  };
}
