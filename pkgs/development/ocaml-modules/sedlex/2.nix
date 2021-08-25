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
  unicodeVersion = "13.0.0";
  baseUrl = "https://www.unicode.org/Public/${unicodeVersion}";

  DerivedCoreProperties = fetchurl {
    url = "${baseUrl}/ucd/DerivedCoreProperties.txt";
    sha256 = "0j12x112cd8fpgazkc8izxnhhpia44p1m36ff8yapslxndcmzm55";
  };
  DerivedGeneralCategory = fetchurl {
    url = "${baseUrl}/ucd/extracted/DerivedGeneralCategory.txt";
    sha256 = "0w6mkz4w79k23bnmwgfxc4yqc2ypv8ilrjn6nk25hrafksbg00j5";
  };
  PropList = fetchurl {
    url = "${baseUrl}/ucd/PropList.txt";
    sha256 = "1ks0585wimygbk2wqi9hqg8gyl25iffvdad5vya1zgsxs8z5lns8";
  };
in
buildDunePackage rec {
  pname = "sedlex";
  version = "2.4";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "sedlex";
    rev = "v${version}";
    sha256 = "13g8az4zqg6hrnxmy3qrasslppzlag13dd1dsr8vlpg2vpfmfv6i";
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
