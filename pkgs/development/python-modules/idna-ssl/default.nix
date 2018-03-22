{ lib, buildPythonPackage, fetchPypi, idna }:

buildPythonPackage rec {
  pname = "idna-ssl";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1293f030bc608e9aa9cdee72aa93c1521bbb9c7698068c61c9ada6772162b979";
  };

  propagatedBuildInputs = [ idna ];

  # Infinite recursion: tests require aiohttp, aiohttp requires idna-ssl
  doCheck = false;

  meta = with lib; {
    description = "Patch ssl.match_hostname for Unicode(idna) domains support";
    homepage = https://github.com/aio-libs/idna-ssl;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
