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

  meta = with lib; {
    description = "UI toolkit for the UNIX terminal built on top of Notty and Lwd";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
    homepage = "https://github.com/let-def/lwd";
  };
}
