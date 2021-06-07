{ lib
, fetchFromGitHub
, fetchurl
, buildDunePackage
, ocaml
, gen
, ppxlib
, uchar
}:

if lib.versionOlder ocaml.version "4.08"
then throw "sedlex is not available for OCaml ${ocaml.version}"
else

let
  unicodeVersion = "12.1.0";
  baseUrl = "https://www.unicode.org/Public/${unicodeVersion}";

  DerivedCoreProperties = fetchurl {
    url = "${baseUrl}/ucd/DerivedCoreProperties.txt";
    sha256 = "0s6sn1yr9qmb2i6gf8dir2zpsbjv1frdfzy3i2yjylzvf637msx6";
  };
  DerivedGeneralCategory = fetchurl {
    url = "${baseUrl}/ucd/extracted/DerivedGeneralCategory.txt";
    sha256 = "1rifzq9ba6c58dn0lrmcb5l5k4ksx3zsdkira3m5p6h4i2wriy3q";
  };
  PropList = fetchurl {
    url = "${baseUrl}/ucd/PropList.txt";
    sha256 = "0gsb1jpj3mnqbjgbavi4l95gl6g4agq58j82km22fdfg63j3w3fk";
  };
in
buildDunePackage rec {
  pname = "sedlex";
  version = "2.3";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "sedlex";
    rev = "v${version}";
    sha256 = "0iw3phlaqr27jdf857hmj5v5hdl0vngbb2h37p2ll18sw991fxar";
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
