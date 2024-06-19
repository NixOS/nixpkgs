{
  lib,
  buildPythonPackage,
  fetchPypi,
  idna,
}:

buildPythonPackage rec {
  pname = "idna-ssl";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a933e3bb13da54383f9e8f35dc4f9cb9eb9b3b78c6b36f311254d6d0d92c6c7c";
  };

  propagatedBuildInputs = [ idna ];

  # Infinite recursion: tests require aiohttp, aiohttp requires idna-ssl
  doCheck = false;

  meta = with lib; {
    description = "Patch ssl.match_hostname for Unicode(idna) domains support";
    homepage = "https://github.com/aio-libs/idna-ssl";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
