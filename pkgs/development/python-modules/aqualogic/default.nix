{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pytestCheckHook
, websockets
}:

buildPythonPackage rec {
  pname = "aqualogic";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "swilson";
    repo = pname;
    rev = version;
    sha256 = "sha256-6YvkSUtBc3Nl/Ap3LjU0IKY2bE4k86XdSoLo+/c8dDs=";
  };

  propagatedBuildInputs = [
    pyserial
    websockets
  ];

  nativeCheckInputs = [
    aiohttp
    pytestCheckHook
  ];

  # With 3.3 the event loop is not terminated after the first test
  # https://github.com/swilson/aqualogic/issues/9
  doCheck = false;

  pythonImportsCheck = [ "aqualogic" ];

  meta = with lib; {
    description = "Python library to interface with Hayward/Goldline AquaLogic/ProLogic pool controllers";
    homepage = "https://github.com/swilson/aqualogic";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
