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
    hash = "sha256-qTPjuxPaVDg/no813E+cueubO3jGs28xElTW0NksbHw=";
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
