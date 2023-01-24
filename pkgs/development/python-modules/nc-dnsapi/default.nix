{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "nc-dnsapi";
  version = "0.1.5";

  src = fetchPypi {
    inherit version;
    pname = "nc_dnsapi";
    hash = "sha256-1fvzr3e0ZAbSDOovhLz5GHJCS6l+K89fbYHoaWxO9cA=";
  };

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "nc_dnsapi" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "API wrapper for the netcup DNS api";
    homepage = "https://github.com/nbuchwitz/nc_dnsapi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ veehaitch trundle ];
  };
}
