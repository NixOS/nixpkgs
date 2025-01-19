{
  lib,
  fetchFromGitHub,
  nix-update-script,

  ocamlPackages,
  which,
  makeWrapper,
  removeReferencesTo,
  installShellFiles,
  z3,
}:

ocamlPackages.buildDunePackage rec {
  pname = "fstar";
  version = "2025.01.17";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    hash = "sha256-D0CofKeDrL6KY1DG5WW0QhRCw73GANo/K0Hu822kDtU=";
  };

  duneVersion = "3";

  nativeBuildInputs = [
    ocamlPackages.menhir
    which
    installShellFiles
    makeWrapper
    removeReferencesTo
  ];

  prePatch = ''
    patchShebangs .scripts/*.sh
    patchShebangs ulib/ml/app/ints/mk_int_file.sh

    # Z3 version is hardcoded. Un-hardcode it.
    find . -type f -exec sed -i 's/--z3version [0-9]\+\.[0-9]\+\.[0-9]\+/--z3version ${z3.version}/g' {} \;
  '';

  buildInputs = with ocamlPackages; [
    batteries
    menhir
    menhirLib
    pprint
    ppx_deriving
    ppx_deriving_yojson
    ppxlib
    process
    sedlex
    stdint
    yojson
    zarith
    memtrace
    mtime
  ];

  buildPhase = ''
    runHook preBuild
    PATH="${lib.makeBinPath [ z3 ]}''${PATH:+:}$PATH" make -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=$out make install

    remove-references-to -t '${ocamlPackages.ocaml}' $out/bin/fstar.exe

    for binary in $out/bin/*; do
      wrapProgram "$binary" --prefix PATH : "${lib.makeBinPath [ z3 ]}"
    done

    src="$(pwd)"
    cd $out
    installShellCompletion --bash $src/.completion/bash/fstar.exe.bash
    installShellCompletion --fish $src/.completion/fish/fstar.exe.fish
    installShellCompletion --zsh --name _fstar.exe $src/.completion/zsh/__fstar.exe
    cd $src

    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(\d{4}\.\d{2}\.\d{2})$"
    ];
  };

  meta = with lib; {
    description = "ML-like functional programming language aimed at program verification";
    homepage = "https://www.fstar-lang.org";
    changelog = "https://github.com/FStarLang/FStar/raw/v${version}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      gebner
      pnmadelaine
    ];
    mainProgram = "fstar.exe";
    platforms = with platforms; darwin ++ linux;
  };
}
