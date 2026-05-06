{
  lib,
  stdenv,
  stdenvNoCC,
  cacert,
  fetchurl,
  fetchzip,
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

  nativeBuildInputs = lib.optionals (!isDarwin) [
    makeWrapper
  ];

  installPhase =
    if isDarwin then
      ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -a $src $out/Applications/Tuple.app
        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        install -Dm755 $src $out/libexec/tuple

        makeWrapper $out/libexec/tuple $out/bin/tuple \
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
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    mainProgram = "tuple";
  };
}
