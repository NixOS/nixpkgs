{
  lib,
  buildDunePackage,
  lwd,
  notty,
}:

buildDunePackage {
  pname = "nottui";

  inherit (lwd) version src;

  propagatedBuildInputs = [
    lwd
    notty
  ];

  meta = {
    description = "UI toolkit for the terminal built on top of Notty and Lwd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
