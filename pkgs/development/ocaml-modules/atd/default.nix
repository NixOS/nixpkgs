{
  lib,
  atdgen-codec-runtime,
  cmdliner,
  menhir,
  easy-format,
  buildDunePackage,
  re,
  yojson,
  nixosTests,
}:

buildDunePackage {
  pname = "atd";
  inherit (atdgen-codec-runtime) version src;

<<<<<<< HEAD
=======
  minimalOCamlVersion = "4.08";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [ menhir ];
  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [
    easy-format
    re
    yojson
  ];

  passthru.tests = {
    smoke-test = nixosTests.atd;
  };

<<<<<<< HEAD
  meta = {
    description = "Syntax for cross-language type definitions";
    homepage = "https://github.com/mjambon/atd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aij ];
=======
  meta = with lib; {
    description = "Syntax for cross-language type definitions";
    homepage = "https://github.com/mjambon/atd";
    license = licenses.mit;
    maintainers = with maintainers; [ aij ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "atdcat";
  };
}
