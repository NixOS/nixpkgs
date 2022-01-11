{ lib
, aiohttp
, bleak
, buildPythonPackage
, csrmesh
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "halohome";
  version = "0.4.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nayaverdier";
    repo = pname;
    rev = version;
    sha256 = "W7cqBJmoBUT0VvXeNKxUK0FfAuprjfvFv6rgyL2gqYQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    bleak
    csrmesh
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "halohome"
  ];

  meta = with lib; {
    description = "Python library to control Eaton HALO Home Smart Lights";
    homepage = "https://github.com/nayaverdier/halohome";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
