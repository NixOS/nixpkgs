{
  lib,
  buildDunePackage,
  lwd,
  notty-community,
}:

buildDunePackage {
  pname = "nottui";

  inherit (lwd) version src;

  propagatedBuildInputs = [
    lwd
    notty-community
  ];

  meta = {
    description = "UI toolkit for the terminal built on top of Notty and Lwd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
