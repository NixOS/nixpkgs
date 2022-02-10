{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, httpx
, pyspnego
, pythonOlder
}:

buildPythonPackage rec {
  pname = "httpx-ntlm";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "httpx_ntlm";
    inherit version;
    sha256 = "sha256-pv/OxgcO0JWk2nCZp+bKlOdX7NqV6V5xZRDy5dd13qQ=";
  };

  propagatedBuildInputs = [
    cryptography
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
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
