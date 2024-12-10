{ lib, fetchurl, buildDunePackage, seq }:

buildDunePackage rec {
  pname = "lwd";
  version = "0.3";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url =
      "https://github.com/let-def/lwd/releases/download/v${version}/lwd-${version}.tbz";
    sha256 = "sha256-H/vyW2tn2OBuWwcmPs8NcINXgFe93MSxRd8dzeoXARI=";
  };

  propagatedBuildInputs = [ seq ];

  meta = with lib; {
    description = "Lightweight reactive documents";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
