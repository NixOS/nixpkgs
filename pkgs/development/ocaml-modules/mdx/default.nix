{ lib, fetchFromGitHub, buildDunePackage, ocaml
, alcotest
, astring, cmdliner_1_1, cppo, fmt, logs, ocaml-version, odoc-parser, ocaml_lwt, re, result, csexp
, pandoc}:

buildDunePackage rec {
  pname = "mdx";
  version = "unstable-2022-02-28";
  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
      owner = "realworldocaml";
      repo = "mdx";
      rev = "cf176d7dc258b40b2e2491aa1df7e8a16ac7452e";
      sha256 = "sha256-SUvcF1JaeD2aCCZvMkUopo/W/meQtYoystht+TYXn9c=";
    };


  # this can be switched back to when the cmdliner_1_1 patch is stabilised
  #src = fetchurl {
  #  url = "https://github.com/realworldocaml/mdx/releases/download/${version}/mdx-${version}.tbz";
  #  sha256 = "sha256-SUvcF1JaeD2aCCZvMkUopo/W/meQtYoystht+TYXn9c=";
  #}


  nativeBuildInputs = [ cppo ];
  buildInputs = [ cmdliner_1_1 ];
  propagatedBuildInputs = [ astring fmt logs result csexp ocaml-version odoc-parser re ];
  checkInputs = [ alcotest ocaml_lwt pandoc ];

  doCheck = true;

  outputs = [ "bin" "lib" "out" ];

  installPhase = ''
    runHook preInstall
    dune install --prefix=$bin --libdir=$lib/lib/ocaml/${ocaml.version}/site-lib ${pname}
    runHook postInstall
  '';

  meta = {
    description = "Executable OCaml code blocks inside markdown files";
    homepage = "https://github.com/realworldocaml/mdx";
    changelog = "https://github.com/realworldocaml/mdx/raw/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "ocaml-mdx";
  };
}
