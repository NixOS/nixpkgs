{
  buildDunePackage,
  fetchurl,
  lib,
}:

buildDunePackage rec {
  pname = "uuuu";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/mirage/uuuu/releases/download/v${version}/uuuu-${version}.tbz";
    hash = "sha256-5+GNk9s36ZocrAjuvlDIiQTq6WF9q0M8j3h/TakrGSg=";
  };

  doCheck = true;

  duneVersion = "3";

  meta = {
    description = "Library to normalize an ISO-8859 input to Unicode code-point";
    homepage = "https://github.com/mirage/uuuu";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "uuuu.generate";
  };
}
