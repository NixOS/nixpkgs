{ lib
, buildPythonPackage
, fetchFromGitHub
, pycares
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiodns";
  version = "3.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "saghul";
    repo = "aiodns";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-JZS53kICsrXDot3CKjG30AOjkYycKpMJvC9yS3c1v5Q=";
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
