{ lib, stdenv, writeScript, fetchFromGitHub, z3, ocamlPackages, makeWrapper, installShellFiles, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "fstar";
  version = "2023.04.25";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    hash = "sha256-LF8eXi/es337QJ2fs5u9pLqegJkh1kDLjK8p4CcSGGc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    z3
    makeWrapper
    installShellFiles
    removeReferencesTo
  ] ++ (with ocamlPackages; [
    ocaml
    dune_3
    findlib
    ocamlbuild
    menhir
  ]);

  buildInputs = with ocamlPackages; [
    batteries
    zarith
    stdint
    yojson
    fileutils
    menhirLib
    pprint
    sedlex
    ppxlib
    ppx_deriving
    ppx_deriving_yojson
    process
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ulib/install-ulib.sh
  '';

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/fstarlib
  '';
  postInstall = ''
    # Remove build artifacts
    find $out -name _build -type d | xargs -I{} rm -rf "{}"
    remove-references-to -t '${ocamlPackages.ocaml}' $out/bin/fstar.exe

    wrapProgram $out/bin/fstar.exe --prefix PATH ":" "${z3}/bin"
    installShellCompletion --bash .completion/bash/fstar.exe.bash
    installShellCompletion --fish .completion/fish/fstar.exe.fish
    installShellCompletion --zsh --name _fstar.exe .completion/zsh/__fstar.exe
  '';

  passthru.updateScript = writeScript "update-fstar" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p git gnugrep common-updater-scripts
      set -eu -o pipefail

      version="$(git ls-remote --tags git@github.com:FStarLang/FStar.git | grep -Po 'v\K\d{4}\.\d{2}\.\d{2}' | sort | tail -n1)"
      update-source-version fstar "$version"
  '';

  meta = with lib; {
    description = "ML-like functional programming language aimed at program verification";
    homepage = "https://www.fstar-lang.org";
    changelog = "https://github.com/FStarLang/FStar/raw/v${version}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ gebner pnmadelaine ];
    mainProgram = "fstar.exe";
    platforms = with platforms; darwin ++ linux;
  };
}
