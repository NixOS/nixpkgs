{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpie,
  requests-ntlm,
}:

buildPythonPackage rec {
  pname = "httpie-ntlm";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sfdXGAwL1gdB6hbPkfxT1H30AqXCh8SmGhSzNeoFUrM=";
  };

  propagatedBuildInputs = [
    httpie
    requests-ntlm
  ];

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
