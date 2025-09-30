{
  lib,
  fetchurl,
  buildDunePackage,
  ptime,
  tyxml,
}:

buildDunePackage (rec {
  pname = "junit";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/Khady/ocaml-junit/releases/download/${version}/junit-${version}.tbz";
    hash = "sha256-j+4lfuQEWq8z8ik/zfA5phWqv8km+tGEzqG/63cbhTM=";
  };

  propagatedBuildInputs = [
    ptime
    tyxml
  ];

  doCheck = true;

  meta = with lib; {
    description = "OCaml package for the creation of JUnit XML reports, proving a typed API to produce valid reports acceptable to Jenkins, comes with packages supporting OUnit and Alcotest";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
    homepage = "https://github.com/Khady/ocaml-junit";
  };
})
