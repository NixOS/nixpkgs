{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildDunePackage,
  gen,
  ppxlib,
  uchar,
  ppx_expect,
  menhir,
  menhirLib,
}:

let
  unicodeVersion = "18.0.0";
  baseUrl = "https://www.unicode.org/Public/${unicodeVersion}";

  DerivedCoreProperties = fetchurl {
    url = "${baseUrl}/ucd/DerivedCoreProperties.txt";
    hash = "sha256-CckoiGoXj8r9k8KeS9WQc6BY5aEAtxbUJctWOrUPaMk=";
  };
  DerivedGeneralCategory = fetchurl {
    url = "${baseUrl}/ucd/extracted/DerivedGeneralCategory.txt";
    hash = "sha256-1rFR0tQO6bGHbSb0F5gPRf+uR7YFXM9yA8sx8HoDD5Q=";
  };
  PropList = fetchurl {
    url = "${baseUrl}/ucd/PropList.txt";
    hash = "sha256-9Dj1Muhze7iicCEmzfnEr141fFjHrPnZ6y/HwaHZVdY=";
  };
  atLeast = v: param: lib.versionAtLeast param.version v;
in
buildDunePackage (finalAttrs: {
  pname = "sedlex";
  version = if lib.versionAtLeast ppxlib.version "0.26.0" then "3.8.1" else "2.5";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "sedlex";
    tag = "v${finalAttrs.version}";
    hash =
      {
        "3.8.1" = "sha256-hFYC1tLsW4uPlwBPyo0Oo1TJM8pRLtmVFm7j2Rv71jQ=";
        "2.5" = "sha256:062a5dvrzvb81l3a9phljrhxfw9nlb61q341q0a6xn65hll3z2wy";
      }
      ."${finalAttrs.version}";
  };

  nativeBuildInputs = lib.optionals (atLeast "3.8" finalAttrs) [ menhir ];
  buildInputs = lib.optionals (atLeast "3.8" finalAttrs) [ menhirLib ];

  propagatedBuildInputs = [
    gen
    ppxlib
  ]
  ++ lib.optionals (!atLeast "3.1" finalAttrs) [
    uchar
  ];

  preBuild = ''
    rm src/generator/data/dune
    ln -s ${DerivedCoreProperties} src/generator/data/DerivedCoreProperties.txt
    ln -s ${DerivedGeneralCategory} src/generator/data/DerivedGeneralCategory.txt
    ln -s ${PropList} src/generator/data/PropList.txt
  '';

  checkInputs = lib.optionals (atLeast "3.1" finalAttrs) [
    ppx_expect
  ];

  doCheck = true;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/ocaml-community/sedlex";
    changelog = "https://github.com/ocaml-community/sedlex/raw/v${finalAttrs.version}/CHANGES";
    description = "OCaml lexer generator for Unicode";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
