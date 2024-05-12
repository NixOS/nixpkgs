{ lib, mkCoqDerivation, coq, serapi, makeWrapper, version ? null }:

mkCoqDerivation rec {
  pname = "coq-lsp";
  owner = "ejgallego";
  namePrefix = [ ];

  useDune = true;

  release."0.1.8+8.16".sha256 = "sha256-dEEAK5IXGjHB8D/fYJRQG/oCotoXJuWLxXB0GQlY2eo=";
  release."0.1.8+8.17".sha256 = "sha256-TmaE+osn/yAPU1Dyni/UTd5w/L2+qyPE3H/g6IWvHLQ=";
  release."0.1.8+8.18".sha256 = "sha256-UYmiDdbax4wxp5dLia/1t1gFyK6UELtJJvDMd5Hd14s=";
  release."0.1.8+8.19".sha256 = "sha256-aO3hUAWEqVxvCF7uJs+S4yrRxSMe/GaLKVfW/vawzNs=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = isEq "8.16"; out = "0.1.8+8.16"; }
    { case = isEq "8.17"; out = "0.1.8+8.17"; }
    { case = isEq "8.18"; out = "0.1.8+8.18"; }
    { case = isEq "8.19"; out = "0.1.8+8.19"; }
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
    maintainers = with maintainers; [ alizter ];
    license = licenses.lgpl21Only;
  };
}
