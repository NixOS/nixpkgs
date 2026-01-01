{
<<<<<<< HEAD
=======
  lib,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildDunePackage,
  dream,
  pure-html,
  ppxlib,
}:

buildDunePackage {
  pname = "dream-html";
<<<<<<< HEAD
  inherit (pure-html) src version meta;

  minimalOCamlVersion = "5.3";
=======
  inherit (pure-html) src version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildInputs = [
    ppxlib
  ];

  propagatedBuildInputs = [
    pure-html
    dream
  ];
<<<<<<< HEAD
=======

  meta = {
    description = "Write HTML directly in your OCaml source files with editor support";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.naora ];
    broken = lib.versionAtLeast ppxlib.version "0.36";
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
