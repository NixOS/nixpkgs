{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, httpx
, ntlm-auth
}:

buildPythonPackage rec {
  pname = "httpx-ntlm";
  version = "0.0.10";

  src = fetchPypi {
    pname = "httpx_ntlm";
    inherit version;
    sha256 = "1rar6smz56y8k5qbgrpabpr639nwvf6whdi093hyakf0m3h9cpfz";
  };

  propagatedBuildInputs = [
    cryptography
    httpx
    ntlm-auth
  ];

  # https://github.com/ulodciv/httpx-ntlm/issues/5
  doCheck = false;

  pythonImportsCheck = [ "httpx_ntlm" ];

  meta = with lib; {
    description = "NTLM authentication support for HTTPX";
    homepage = "https://github.com/ulodciv/httpx-ntlm";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
