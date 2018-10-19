{ lib, buildPythonPackage, fetchPypi, defusedxml, isodate, xmlsec }:

buildPythonPackage rec {
  pname = "python3-saml";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r6rcmh5ylmz65ji4sm650j5i2i25289ipd19awinr347sn5q8y8";
  };

  propagatedBuildInputs = [
    defusedxml
    isodate
    xmlsec
  ];

  # Tests are missing (https://github.com/onelogin/python3-saml/issues/115)
  doCheck = false;

  meta = with lib; {
    description = "OneLogin's SAML Python 3 Toolkit";
    homepage = https://github.com/onelogin/python3-saml;
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
