{
  lib,
  fetchurl,
  buildDunePackage,
  seq,
}:

buildDunePackage rec {
  pname = "lwd";
  version = "0.4";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/let-def/lwd/releases/download/v${version}/lwd-${version}.tbz";
    hash = "sha256-nnFltlBWfPOerF4HuVNGzXcZxRSdsM+abeD5ZdQ+x8U=";
  };

  propagatedBuildInputs = [ seq ];

  meta = {
    description = "Lightweight reactive documents";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
