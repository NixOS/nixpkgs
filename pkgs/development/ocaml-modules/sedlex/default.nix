{ lib
, fetchFromGitHub
, fetchurl
, buildDunePackage
, ocaml
, gen
, ppxlib
, uchar
}:

let param =
  if lib.versionAtLeast ppxlib.version "0.26.0" then {
    version = "3.0";
    sha256 = "sha256-+4ggynMznVfjviMBjXil8CXdMByq4kSmDz6P2PyEETA=";
  } else {
    version = "2.5";
    sha256 = "sha256:062a5dvrzvb81l3a9phljrhxfw9nlb61q341q0a6xn65hll3z2wy";
  }
; in

let
  unicodeVersion = "15.0.0";
  baseUrl = "https://www.unicode.org/Public/${unicodeVersion}";

  DerivedCoreProperties = fetchurl {
    url = "${baseUrl}/ucd/DerivedCoreProperties.txt";
    sha256 = "sha256-02cpC8CGfmtITGg3BTC90aCLazJARgG4x6zK+D4FYo0=";
  };
  DerivedGeneralCategory = fetchurl {
    url = "${baseUrl}/ucd/extracted/DerivedGeneralCategory.txt";
    sha256 = "sha256-/imkXAiCUA5ZEUCqpcT1Bn5qXXRoBhSK80QAxIucBvk=";
  };
  PropList = fetchurl {
    url = "${baseUrl}/ucd/PropList.txt";
    sha256 = "sha256-4FwKKBHRE9rkq9gyiEGZo+qNGH7huHLYJAp4ipZUC/0=";
  };
in
buildDunePackage rec {
  pname = "sedlex";
  inherit (param) version;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "sedlex";
    rev = "v${version}";
    inherit (param) sha256;
  };

  propagatedBuildInputs = [
    gen uchar ppxlib
  ];

  preBuild = ''
    rm src/generator/data/dune
    ln -s ${DerivedCoreProperties} src/generator/data/DerivedCoreProperties.txt
    ln -s ${DerivedGeneralCategory} src/generator/data/DerivedGeneralCategory.txt
    ln -s ${PropList} src/generator/data/PropList.txt
  '';

  doCheck = true;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/ocaml-community/sedlex";
    changelog = "https://github.com/ocaml-community/sedlex/raw/v${version}/CHANGES";
    description = "An OCaml lexer generator for Unicode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.marsam ];
  };
}
