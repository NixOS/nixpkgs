{
  lib,
  stdenvNoCC,
  shellcheck,
  installShellFiles,
  makeWrapper,
  runtimeShellPackage,

  coreutils,
  diffutils,
  git,
  gnugrep,
  gnused,
  jq,
  nix,
  curl,
  python3,
  python3Packages,
}:

stdenvNoCC.mkDerivation {
  name = "common-updater-scripts";

  __structuredAttrs = true;
  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;
  dontUpdateAutotoolsGnuConfigScripts = true;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
    installShellFiles
  ];

  buildInputs = [
    python3
    runtimeShellPackage
  ];

  pythonPath = [
    python3Packages.beautifulsoup4
    python3Packages.requests
  ];

  pythonScripts = [
    "list-directory-versions"
  ];

  bashScripts = [
    "list-archive-two-levels-versions"
    "list-git-tags"
    "mark-broken"
    "update-source-version"
  ];

  src = ./scripts;

  installPhase =
    let
      bashScriptInputs = [
        coreutils
        diffutils
        git
        gnugrep
        gnused
        jq
        nix
        curl
      ];
    in
    ''
      runHook preInstall

      installBin "''${bashScripts[@]}" "''${pythonScripts[@]}"

      # wrap non python scripts
      for f in ''${bashScripts[@]}; do
        wrapProgram $out/bin/$f --prefix PATH : "${lib.makeBinPath bashScriptInputs}"
      done

      # wrap python scripts
      buildPythonPath "''${pythonPath[*]}"
      for f in ''${pythonScripts[@]}; do
        patchPythonScript $out/bin/$f
        wrapProgram $out/bin/$f --prefix PATH : "${lib.makeBinPath [ nix ]}"
      done

      runHook postInstall
    '';

  doCheck = true;
  nativeCheckInputs = [ shellcheck ];

  checkPhase = ''
    runHook preCheck

    for file in ''${bashScripts[@]}; do
      printf "checking '%s' with shellcheck...\n" "$file"
      shellcheck "$file"
    done

    runHook postCheck
  '';
}
