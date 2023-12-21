{ stdenv, lib, fetchPypi, buildPythonPackage, cryptography,
python-ldap, requests, six }:

buildPythonPackage rec {
  pname = "dogtag-pki";
  version = "11.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rQSnQPNYr5SyeNbKoFAbnGb2X/8utrfWLa8gu93hy2w=";
  };

  buildInputs = [ cryptography python-ldap ];
  pythonImportsCheck = [ "pki" ];
  propagatedBuildInputs = [ requests six ];

  meta = with lib; {
    description = "An enterprise-class Certificate Authority";
    homepage    = "https://github.com/dogtagpki/pki";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ s1341 ];
  };
}
