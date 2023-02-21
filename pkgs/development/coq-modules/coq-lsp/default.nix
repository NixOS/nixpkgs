{ lib, mkCoqDerivation, coq, serapi, makeWrapper, version ? null }:

mkCoqDerivation rec {
  pname = "coq-lsp";
  owner = "ejgallego";
  namePrefix = [ ];

  useDune = true;

  release."0.1.6.1+8.16".sha256 = "sha256-aX8/pN4fVYaF7ZEPYfvYpEZLiQM++ZG1fAhiLftQ9Aw=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = isEq "8.16"; out = "0.1.6.1+8.16"; }
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
    maintainers = with maintainers; [ marsam ];
    license = licenses.lgpl21Only;
  };
}
