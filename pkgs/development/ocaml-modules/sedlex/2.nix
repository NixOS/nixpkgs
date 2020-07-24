{ lib
, fetchFromGitHub
, fetchurl
, buildDunePackage
, ocaml
, gen
, ppx_tools_versioned
, ocaml-migrate-parsetree
, uchar
}:

if lib.versionOlder ocaml.version "4.02.3"
then throw "sedlex is not available for OCaml ${ocaml.version}"
else

let
  DerivedCoreProperties = fetchurl {
    url = "https://www.unicode.org/Public/12.1.0/ucd/DerivedCoreProperties.txt";
    sha256 = "0s6sn1yr9qmb2i6gf8dir2zpsbjv1frdfzy3i2yjylzvf637msx6";
  };
  DerivedGeneralCategory = fetchurl {
    url = "https://www.unicode.org/Public/12.1.0/ucd/extracted/DerivedGeneralCategory.txt";
    sha256 = "1rifzq9ba6c58dn0lrmcb5l5k4ksx3zsdkira3m5p6h4i2wriy3q";
  };
  PropList = fetchurl {
    url = "https://www.unicode.org/Public/12.1.0/ucd/PropList.txt";
    sha256 = "0gsb1jpj3mnqbjgbavi4l95gl6g4agq58j82km22fdfg63j3w3fk";
  };
in
buildDunePackage rec {
  pname = "sedlex";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "sedlex";
    rev = "v${version}";
    sha256 = "05f6qa8x3vhpdz1fcnpqk37fpnyyq13icqsk2gww5idjnh6kng26";
  };

  propagatedBuildInputs = [
    gen uchar ocaml-migrate-parsetree ppx_tools_versioned
  ];

  preBuild = ''
    ln -s ${DerivedCoreProperties} src/generator/data/DerivedCoreProperties.txt
    ln -s ${DerivedGeneralCategory} src/generator/data/DerivedGeneralCategory.txt
    ln -s ${PropList} src/generator/data/PropList.txt
  '';

  doCheck = true;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/ocaml-community/sedlex";
    description = "An OCaml lexer generator for Unicode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.marsam ];
  };
}
