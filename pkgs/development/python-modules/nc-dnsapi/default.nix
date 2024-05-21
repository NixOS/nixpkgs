{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "nc-dnsapi";
  version = "0.1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nbuchwitz";
    repo = "nc_dnsapi";
    rev = "v${version}";
    hash = "sha256-OE4+wJbJbUZ+YB5J5OyvytLFCcrnXCeZEqmphHKKprQ=";
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
