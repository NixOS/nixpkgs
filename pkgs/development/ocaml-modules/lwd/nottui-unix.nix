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

<<<<<<< HEAD
  meta = {
    description = "UI toolkit for the UNIX terminal built on top of Notty and Lwd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
=======
  meta = with lib; {
    description = "UI toolkit for the UNIX terminal built on top of Notty and Lwd";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/let-def/lwd";
  };
}
