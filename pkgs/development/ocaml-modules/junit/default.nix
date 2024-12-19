{
  lib,
  fetchurl,
  buildDunePackage,
  ptime,
  tyxml,
}:

buildDunePackage (rec {
  pname = "junit";
  version = "2.0.2";

  src = fetchurl {
    url = "https://github.com/Khady/ocaml-junit/releases/download/${version}/junit-${version}.tbz";
    sha256 = "00bbx5j8vsy9fqbc04xa3lsalaxicirmbczr65bllfk1afv43agx";
  };

  propagatedBuildInputs = [
    ptime
    tyxml
  ];

  doCheck = true;

  meta = with lib; {
    description = "ocaml-junit is an OCaml package for the creation of JUnit XML reports, proving a typed API to produce valid reports acceptable to Jenkins, comes with packages supporting OUnit and Alcotest";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
    homepage = "https://github.com/Khady/ocaml-junit";
  };
})
