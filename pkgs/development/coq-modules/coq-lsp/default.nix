{ lib, mkCoqDerivation, coq, serapi, makeWrapper, version ? null }:

mkCoqDerivation rec {
  pname = "coq-lsp";
  owner = "ejgallego";
  namePrefix = [ ];

  useDune = true;

  release."0.1.7+8.16".sha256 = "sha256-ZBxwrnnCmT5q4C7ocQ+M+aSJQNnEjeN2HFw4bzPozYs=";
  release."0.1.7+8.17".sha256 = "sha256-f671wzGQannGjRbmBRHFKXz24BTPX7oVeHUxnv4Vd6Y=";
  release."0.1.7+8.18".sha256 = "sha256-J+bRIzjdIPRu7DvAGVBKB43O3UJliTo8XQ87OTzsFyc=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = isEq "8.16"; out = "0.1.7+8.16"; }
    { case = isEq "8.17"; out = "0.1.7+8.17"; }
    { case = isEq "8.18"; out = "0.1.7+8.18"; }
  ] null;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    dune install ${pname} --prefix=$out
    wrapProgram $out/bin/coq-lsp --prefix OCAMLPATH : $OCAMLPATH
    runHook postInstall
  '';

  propagatedBuildInputs = [ serapi ]
    ++ (with coq.ocamlPackages; [ camlp-streams dune-build-info menhir uri yojson ]);

  meta = with lib; {
    description = "Language Server Protocol and VS Code Extension for Coq";
    homepage = "https://github.com/ejgallego/coq-lsp";
    changelog = "https://github.com/ejgallego/coq-lsp/blob/${defaultVersion}/CHANGES.md";
    maintainers = with maintainers; [ alizter marsam ];
    license = licenses.lgpl21Only;
  };
}
