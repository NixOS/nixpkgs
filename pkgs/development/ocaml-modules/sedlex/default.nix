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
        version = "3.7";
        sha256 = "sha256-ucqrJkzS6cVogGUf1vU8oBpSryneMBqTjzxwsOi6Egs=";
      }
    else
      {
        version = "2.5";
        sha256 = "sha256:062a5dvrzvb81l3a9phljrhxfw9nlb61q341q0a6xn65hll3z2wy";
      };
in

let
  unicodeVersion = "17.0.0";
  baseUrl = "https://www.unicode.org/Public/${unicodeVersion}";

  DerivedCoreProperties = fetchurl {
    url = "${baseUrl}/ucd/DerivedCoreProperties.txt";
    hash = "sha256-JMf+0RlcSC+q79XB5+uCHF7h+23gfs26pktWqZ2iLAg=";
  };
  DerivedGeneralCategory = fetchurl {
    url = "${baseUrl}/ucd/extracted/DerivedGeneralCategory.txt";
    hash = "sha256-1i5bq3DKdPCZND9xIk+gUcsf3WGhq0XASIxEz8C2EC4=";
  };
  PropList = fetchurl {
    url = "${baseUrl}/ucd/PropList.txt";
    hash = "sha256-Ew3N3Kra8HEAi9/OHndD4E/fvJEIhvAX2fmskx2MZN0=";
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
