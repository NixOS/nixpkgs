{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hole";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
     owner = "home-assistant-ecosystem";
     repo = "python-hole";
     rev = "0.7.0";
     sha256 = "10d3cksfv29g00z6s1iqacspd7iybwsn7wlyj21flknd74ww78yj";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [
    "hole"
  ];

  meta = with lib; {
    description = "Python API for interacting with a Pihole instance.";
    homepage = "https://github.com/home-assistant-ecosystem/python-hole";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
