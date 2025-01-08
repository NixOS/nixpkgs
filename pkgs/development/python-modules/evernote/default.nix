{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  oauth2,
}:

buildPythonPackage rec {
  pname = "evernote";
  version = "1.25.3";
  format = "setuptools";
  disabled = !isPy27; # some dependencies do not work with py3

  src = fetchPypi {
    inherit pname version;
    sha256 = "796847e0b7517e729041c5187fa1665c3f6fc0491cb4d71fb95a62c4f22e64eb";
  };

  propagatedBuildInputs = [ oauth2 ];

  meta = with lib; {
    description = "Evernote SDK for Python";
    homepage = "https://dev.evernote.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ hbunke ];
  };
}
