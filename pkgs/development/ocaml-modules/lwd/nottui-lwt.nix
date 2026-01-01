{
  lib,
  buildDunePackage,
  lwd,
  lwt,
  nottui,
}:

buildDunePackage {
  pname = "nottui-lwt";

  inherit (lwd) version src;

  propagatedBuildInputs = [
    lwt
    nottui
  ];

<<<<<<< HEAD
  meta = {
    description = "Run Nottui UIs in Lwt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
=======
  meta = with lib; {
    description = "Run Nottui UIs in Lwt";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/let-def/lwd";
  };
}
