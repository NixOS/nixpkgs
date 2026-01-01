{
  buildDunePackage,
  fetchurl,
  lib,
  ppxlib,
<<<<<<< HEAD
  version ? if lib.versionAtLeast ppxlib.version "0.36" then "0.17.0" else "0.16.0",
}:

buildDunePackage (finalAttrs: {
=======
}:

let
  version = "0.16.0";
in
buildDunePackage {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "reason-react-ppx";
  inherit version;
  minimalOCamlVersion = "4.14";
  src = fetchurl {
<<<<<<< HEAD
    url = "https://github.com/reasonml/reason-react/releases/download/${finalAttrs.version}/reason-react-${finalAttrs.version}.tbz";
    hash =
      {
        "0.16.0" = "sha256-esPB+mvHHTQ3mUYILrkOjMELJxRDIsWleFcxIwOPQ1w=";
        "0.17.0" = "sha256-ArZ6CL1UjcGYPBvGnvQX7Qa16+mQT3T8mETHprT/MYw=";
      }
      ."${finalAttrs.version}";
=======
    url = "https://github.com/reasonml/reason-react/releases/download/${version}/reason-react-${version}.tbz";
    hash = "sha256-esPB+mvHHTQ3mUYILrkOjMELJxRDIsWleFcxIwOPQ1w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  buildInputs = [ ppxlib ];
  doCheck = false; # Needs to run in reason-react, see default.nix
  meta = {
    description = "React.js JSX PPX";
    homepage = "https://github.com/reasonml/reason-react";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vog ];
<<<<<<< HEAD
  };
})
=======
    broken = lib.versionAtLeast ppxlib.version "0.36";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
