{ lib
, buildPythonPackage
, fetchPypi
, httpx
, pyspnego
, pythonOlder
}:

buildPythonPackage rec {
  pname = "httpx-ntlm";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "httpx_ntlm";
    inherit version;
    hash = "sha256-Qb6KK6hRQ0hOYX3LkX1LGeOuEq/caIYipJAQNJk7U+Q=";
  };

  propagatedBuildInputs = [
    httpx
    pyspnego
  ];

  # https://github.com/ulodciv/httpx-ntlm/issues/5
  doCheck = false;

  pythonImportsCheck = [
    "httpx_ntlm"
  ];

  meta = with lib; {
    description = "NTLM authentication support for HTTPX";
    homepage = "https://github.com/ulodciv/httpx-ntlm";
    changelog = "https://github.com/ulodciv/httpx-ntlm/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
