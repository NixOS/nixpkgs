{
  lib,
  buildDunePackage,
  lwd,
  nottui,
  notty,
}:

buildDunePackage {
  pname = "nottui-unix";

  inherit (lwd) version src;

  propagatedBuildInputs = [
    lwd
    nottui
    notty
  ];

  meta = {
    description = "UI toolkit for the UNIX terminal built on top of Notty and Lwd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/let-def/lwd";
  };
}
