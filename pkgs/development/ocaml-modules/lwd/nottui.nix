{ lib, buildDunePackage, lwd, notty }:

buildDunePackage {
  pname = "nottui";

  inherit (lwd) version src;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [ lwd notty ];

  meta = with lib; {
    description = "UI toolkit for the terminal built on top of Notty and Lwd";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
