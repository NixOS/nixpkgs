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
    hash = "sha256-eWhH4LdRfnKQQcUYf6FmXD9vwEkctNcfuVpixPIuZOs=";
  };

  propagatedBuildInputs = [ oauth2 ];

  meta = with lib; {
    description = "Evernote SDK for Python";
    homepage = "https://dev.evernote.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ hbunke ];
  };
}
