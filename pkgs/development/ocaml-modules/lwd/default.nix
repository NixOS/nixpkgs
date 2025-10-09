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

  meta = with lib; {
    description = "Lightweight reactive documents";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
