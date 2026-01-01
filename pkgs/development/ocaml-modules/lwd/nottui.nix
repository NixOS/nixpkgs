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

<<<<<<< HEAD
  meta = {
    description = "UI toolkit for the terminal built on top of Notty and Lwd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
=======
  meta = with lib; {
    description = "UI toolkit for the terminal built on top of Notty and Lwd";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/let-def/lwd";
  };
}
