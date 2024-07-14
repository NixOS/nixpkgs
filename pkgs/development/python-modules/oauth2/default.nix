{
  lib,
  buildPythonPackage,
  fetchPypi,
  httplib2,
  mock,
  coverage,
}:

buildPythonPackage rec {
  pname = "oauth2";
  version = "1.9.0.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wAaoXnxgEHx8xtobGEtccZ9t1yAgmBlt+m5V32abWb8=";
  };

  propagatedBuildInputs = [ httplib2 ];
  buildInputs = [
    mock
    coverage
  ];

  # ServerNotFoundError: Unable to find the server at oauth-sandbox.sevengoslings.net
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/simplegeo/python-oauth2";
    description = "Library for OAuth version 1.0";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
