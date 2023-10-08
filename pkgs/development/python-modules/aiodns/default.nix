{ lib
, buildPythonPackage
, fetchFromGitHub
, pycares
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiodns";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "saghul";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dIr6ea4vkBwahmAgO54QnqD2Dfv43wBOIadrzx4Erns=";
  };

  propagatedBuildInputs = [
    pycares
  ];

  # Could not contact DNS servers
  doCheck = false;

  pythonImportsCheck = [
    "aiodns"
  ];

  meta = with lib; {
    description = "Simple DNS resolver for asyncio";
    homepage = "https://github.com/saghul/aiodns";
    changelog = "https://github.com/saghul/aiodns/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
