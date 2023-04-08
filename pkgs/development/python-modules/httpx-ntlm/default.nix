{ lib
, buildPythonPackage
, fetchPypi
, httpx
, pyspnego
, pythonOlder
}:

buildPythonPackage rec {
  pname = "httpx-ntlm";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "httpx_ntlm";
    inherit version;
    hash = "sha256-a1a5laZ4tNOtpVDFCK1t2IXWbyJytZMhuad2JtmA52I=";
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
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
