{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  cudf,
}:

buildDunePackage rec {
  pname = "mccs";
  version = "1.1+19";

  src = fetchFromGitHub {
    owner = "AltGr";
    repo = "ocaml-mccs";
    rev = version;
    hash = "sha256-xvcqPXyzVGXXFYRVdFPaCfieFEguWffWVB04ImEuPvQ=";
  };

  propagatedBuildInputs = [
    cudf
  ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Library providing a multi criteria CUDF solver, part of MANCOOSI project";
    downloadPage = "https://github.com/AltGr/ocaml-mccs";
    homepage = "https://www.i3s.unice.fr/~cpjm/misc/";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Library providing a multi criteria CUDF solver, part of MANCOOSI project";
    downloadPage = "https://github.com/AltGr/ocaml-mccs";
    homepage = "https://www.i3s.unice.fr/~cpjm/misc/";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lgpl21
      gpl3
    ];
    maintainers = [ ];
  };
}
