{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pytestCheckHook,
  websockets,
}:

buildPythonPackage rec {
  pname = "aqualogic";
  version = "3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "swilson";
    repo = pname;
    rev = version;
    hash = "sha256-hBg02Wypd+MyqM2SUD53djhm5OMP2QAmsp8Stf+UT2c=";
  };

  propagatedBuildInputs = [
    aiohttp
    pyserial
    websockets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # With 3.4 the event loop is not terminated after the first test
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
