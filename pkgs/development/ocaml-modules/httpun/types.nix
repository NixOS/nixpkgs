{
  lib,
  buildDunePackage,
  fetchurl,
  faraday,
}:

buildDunePackage rec {
  pname = "httpun-types";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/httpun/releases/download/${version}/httpun-${version}.tbz";
    hash = "sha256-os4n70yFro4cEAjR49Xok9ayEbk0WGod0pQvfbaHvSw=";
  };

  propagatedBuildInputs = [ faraday ];

  meta = with lib; {
    description = "Common HTTP/1.x types";
    homepage = "https://github.com/anmonteiro/httpun";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
