{
  lib,
  fetchurl,
  buildDunePackage,
  angstrom,
  base64,
  bigstringaf,
  faraday,
  gluten,
  httpun,
  alcotest,
}:

buildDunePackage rec {
  pname = "httpun-ws";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/httpun-ws/releases/download/${version}/httpun-ws-${version}.tbz";
    hash = "sha256-6uDNLg61tPyctthitxFqbw/IUDsuQ5BGvw5vTLLCl/0=";
  };

  propagatedBuildInputs = [
    angstrom
    base64
    bigstringaf
    faraday
    gluten
    httpun
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Websocket implementation for httpun";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/anmonteiro/httpun-ws";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
