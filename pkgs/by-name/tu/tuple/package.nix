{
  lib,
  stdenv,
  stdenvNoCC,
  cacert,
  fetchurl,
  fetchzip,
  installShellFiles,
  makeWrapper,
}:

let
  inherit (stdenvNoCC.hostPlatform) isDarwin system;
  sources = import ./sources.nix { inherit fetchurl fetchzip; };

  tupleStdenv = if isDarwin then stdenvNoCC else stdenv;
in
tupleStdenv.mkDerivation {
  pname = "tuple";

  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;

  sourceRoot = lib.optionalString isDarwin ".";

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = !isDarwin;

  nativeBuildInputs =
    if isDarwin then
      [
        installShellFiles
      ]
    else
      [
        makeWrapper
      ];

  installPhase =
    if isDarwin then
      ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -a $src $out/Applications/Tuple.app
        mkdir -p $out/bin
        ln -s ../Applications/Tuple.app/Contents/SharedSupport/bin/tuple $out/bin/tuple
        # Generate completions from the source path: running the app after
        # copying it into $out makes macOS lock the bundle (App Management),
        # after which any chmod inside it fails with EPERM (fixupPhase).
        $src/Contents/SharedSupport/bin/tuple completion bash >tuple.bash
        $src/Contents/SharedSupport/bin/tuple completion fish >tuple.fish
        $src/Contents/SharedSupport/bin/tuple completion zsh >tuple.zsh
        installShellCompletion tuple.{bash,fish,zsh}
        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        install -Dm755 $src $out/bin/.tuple-wrapped

        makeWrapper $out/bin/.tuple-wrapped $out/bin/tuple \
          --set-default SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt

        runHook postInstall
      '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Remote pair programming app";
    homepage = "https://tuple.app";
    changelog = "https://tuple.app/changelog";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.maxbrunet ];
    platforms = builtins.attrNames sources;
    mainProgram = "tuple";
  };
}
