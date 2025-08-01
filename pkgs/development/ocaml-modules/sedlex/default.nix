{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildDunePackage,
  gen,
  ppxlib,
  uchar,
  ppx_expect,
}:

let
  param =
    if lib.versionAtLeast ppxlib.version "0.26.0" then
      {
        version = "3.6";
        sha256 = "sha256-NiNqur7sce6dxictVB+saOC1c4N/EO/3Ici/icsGkIA=";
      }
    else
      {
        version = "2.5";
        sha256 = "sha256:062a5dvrzvb81l3a9phljrhxfw9nlb61q341q0a6xn65hll3z2wy";
      };
in

let
  unicodeVersion = "16.0.0";
  baseUrl = "https://www.unicode.org/Public/${unicodeVersion}";

  DerivedCoreProperties = fetchurl {
    url = "${baseUrl}/ucd/DerivedCoreProperties.txt";
    sha256 = "sha256-OdNRYfKVRJf2ngi9uecBST9Haj0wIi3iACj+2jbB2r0=";
  };
  DerivedGeneralCategory = fetchurl {
    url = "${baseUrl}/ucd/extracted/DerivedGeneralCategory.txt";
    sha256 = "sha256-dnardVpB74IQhGAjhWnmCtZcGR3a/mGzbGdl7BNT8pM=";
  };
  PropList = fetchurl {
    url = "${baseUrl}/ucd/PropList.txt";
    sha256 = "sha256-U9YUUI4qCyMFqKohzWDZk96TJs32WZNmDfzORQNUhYM=";
  };
  atLeast31 = lib.versionAtLeast param.version "3.1";
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
    gen
    ppxlib
  ]
  ++ lib.optionals (!atLeast31) [
    uchar
  ];

  preBuild = ''
    rm src/generator/data/dune
    ln -s ${DerivedCoreProperties} src/generator/data/DerivedCoreProperties.txt
    ln -s ${DerivedGeneralCategory} src/generator/data/DerivedGeneralCategory.txt
    ln -s ${PropList} src/generator/data/PropList.txt
  '';

  checkInputs = lib.optionals atLeast31 [
    ppx_expect
  ];

  doCheck = true;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/ocaml-community/sedlex";
    changelog = "https://github.com/ocaml-community/sedlex/raw/v${version}/CHANGES";
    description = "OCaml lexer generator for Unicode";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
