{ lib
, buildPythonPackage
, fetchPypi
, httpie
, requests_ntlm
}:

buildPythonPackage rec {
  pname = "httpie-ntlm";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1f757180c0bd60741ea16cf91fc53d47df402a5c287c4a61a14b335ea0552b3";
  };

  propagatedBuildInputs = [ httpie requests_ntlm ];

  # Package have no tests
  doCheck = false;

  pythonImportsCheck = [ "httpie_ntlm" ];

  meta = with lib; {
    description = "NTLM auth plugin for HTTPie";
    homepage = "https://github.com/httpie/httpie-ntlm";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
