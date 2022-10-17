{ lib, buildDunePackage, fetchFromGitLab, ff-sig, zarith
, zarith_stubs_js, integers_stubs_js, integers, hex
, ff-pbt, bisect_ppx, alcotest
}:

buildDunePackage rec {
  pname = "bls12-381";
  version = "3.0.0";

  src = fetchFromGitLab {
    owner = "dannywillems";
    repo = "ocaml-bls12-381";
    rev = "4bbc7818e9ccd025c5e32006f8a9de370739bc43";
    sha256 = "/Rw0mQvTfHyPqosWFPv+1FoY5Dwuwv9mB8UYjjHxodE=";
  };

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    ff-sig
    zarith
    zarith_stubs_js
    integers_stubs_js
    integers
    hex
  ];

  checkInputs = [
    ff-pbt
    bisect_ppx
    alcotest
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-bls12-381";
    description = "OCaml binding for bls12-381 from librustzcash";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
