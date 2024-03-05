{ callPackage
, fetchFromGitHub
, installShellFiles
, lib
, makeWrapper
, ocamlPackages
, removeReferencesTo
, stdenv
, writeScript
, z3
}:

let

  version = "2024.01.13";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    hash = "sha256-xjSWDP8mSjLcn+0hsRpEdzsBgBR+mKCZB8yLmHl+WqE=";
  };

  fstar-dune = ocamlPackages.callPackage ./dune.nix { inherit version src; };

  fstar-ulib = callPackage ./ulib.nix { inherit version src fstar-dune z3; };

in

stdenv.mkDerivation {
  pname = "fstar";
  inherit version src;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    removeReferencesTo
  ];

  inherit (fstar-dune) propagatedBuildInputs;

  dontBuild = true;

  installPhase = ''
    mkdir $out

    CP="cp -r --no-preserve=mode"
    $CP ${fstar-dune}/* $out
    $CP ${fstar-ulib}/* $out

    PREFIX=$out make -C src/ocaml-output install-sides

    chmod +x $out/bin/fstar.exe
    wrapProgram $out/bin/fstar.exe --prefix PATH ":" ${z3}/bin
    remove-references-to -t '${ocamlPackages.ocaml}' $out/bin/fstar.exe

    substituteInPlace $out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/fstar/dune-package \
      --replace ${fstar-dune} $out

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
