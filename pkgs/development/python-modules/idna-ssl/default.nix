{ lib, buildPythonPackage, fetchPypi, idna }:

buildPythonPackage rec {
  pname = "idna_ssl";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1227e44039bd31e02adaeafdbba61281596d623d222643fb021f87f2144ea147";
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
