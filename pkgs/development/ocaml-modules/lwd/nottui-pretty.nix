{
  lib,
  buildDunePackage,
  lwd,
  nottui,
}:

buildDunePackage {
  pname = "nottui-pretty";

  inherit (lwd) version src;

  propagatedBuildInputs = [ nottui ];

<<<<<<< HEAD
  meta = {
    description = "Pretty-printer based on PPrint rendering UIs";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
=======
  meta = with lib; {
    description = "Pretty-printer based on PPrint rendering UIs";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/let-def/lwd";
  };
}
