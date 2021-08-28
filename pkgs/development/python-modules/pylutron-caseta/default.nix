{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytest-asyncio
, pytest-sugar
, pytest-timeout
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylutron-caseta";
  version = "0.9.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "gurumitts";
    repo = pname;
    rev = "v${version}";
    sha256 = "07mz4hn0455qmfqs4xcqlhbf3qvrnmifd0vzpcqlqaqcn009iahq";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  checkInputs = [
    pytest-asyncio
    pytest-sugar
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylutron_caseta" ];

  meta = with lib; {
    description = "Python module o control Lutron Caseta devices";
    homepage = "https://github.com/gurumitts/pylutron-caseta";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
