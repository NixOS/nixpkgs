{ lib
, buildPythonPackage
, fetchFromGitHub
, pycares
, pythonOlder
, typing
}:

buildPythonPackage rec {
  pname = "aiodns";
  version = "3.1.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "saghul";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-JZS53kICsrXDot3CKjG30AOjkYycKpMJvC9yS3c1v5Q=";
  };

  propagatedBuildInputs = [
    pycares
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing
  ];

  # Could not contact DNS servers
  doCheck = false;

  pythonImportsCheck = [ "aiodns" ];

  meta = with lib; {
    description = "Simple DNS resolver for asyncio";
    homepage = "https://github.com/saghul/aiodns";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
