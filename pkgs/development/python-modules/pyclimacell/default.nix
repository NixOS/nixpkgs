{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "pyclimacell";
  version = "0.18.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "raman325";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pxlh3lwd1az6v7vbaz9kv6ngqxf34iddp7vr0d0p8apbvinwrha";
  };

  propagatedBuildInputs = [
    aiohttp
    pytz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyclimacell" ];

  meta = with lib; {
    description = "Python client for ClimaCell API";
    homepage = "https://github.com/raman325/pyclimacell";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
