{ lib
, fetchFromGitHub
, fetchurl
, buildDunePackage
, ocaml
, gen
, ppxlib
, uchar
}:

let
  unicodeVersion = "14.0.0";
  baseUrl = "https://www.unicode.org/Public/${unicodeVersion}";

  DerivedCoreProperties = fetchurl {
    url = "${baseUrl}/ucd/DerivedCoreProperties.txt";
    sha256 = "sha256:1g77s8g9443dd92f82pbkim7rk51s7xdwa3mxpzb1lcw8ryxvvg3";
  };
  DerivedGeneralCategory = fetchurl {
    url = "${baseUrl}/ucd/extracted/DerivedGeneralCategory.txt";
    sha256 = "sha256:080l3bwwppm7gnyga1hzhd07b55viklimxpdsx0fsxhr8v47krnd";
  };
  PropList = fetchurl {
    url = "${baseUrl}/ucd/PropList.txt";
    sha256 = "sha256:08k75jzl7ws9l3sm1ywsj24qa4qvzn895wggdpp5nyj1a2wgvpbb";
  };
in
buildDunePackage rec {
  pname = "sedlex";
  version = "2.5";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "sedlex";
    rev = "v${version}";
    sha256 = "sha256:062a5dvrzvb81l3a9phljrhxfw9nlb61q341q0a6xn65hll3z2wy";
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
