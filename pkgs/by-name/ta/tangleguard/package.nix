{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.15.0";
  target = stdenv.hostPlatform.rust.rustcTarget;
  hashes = {
    aarch64-apple-darwin = "aaf892452cb20bba2a788fcd5eebfd33b5c2e6408dfc14badec26c3dc1c7dc7b";
    x86_64-apple-darwin = "04f99dc28efa643147bde828383ebf43bd3c23c35d0c271c768b23498ce10aec";
    aarch64-unknown-linux-gnu = "7c0d928a865738c0f04312fef93cc0282dadcb083f8cc10f73225acf7060cce9";
    x86_64-unknown-linux-gnu = "1434f3f1ac4dafc190107eaa72ad9ced49cc9e4a57170f6b3e3ff49b76db8508";
  };
in
stdenv.mkDerivation {
  pname = "tangleguard";
  inherit version;

  src = fetchurl {
    url = "https://tangleguard-cli-builds.s3.eu-central-1.amazonaws.com/v${version}/tangleguard-cli_${version}_${target}.tar.gz";
    sha256 = hashes.${target} or (throw "tangleguard: unsupported platform ${target}");
  };

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 tangleguard-cli* $out/bin/tangleguard-cli
    runHook postInstall
  '';

  meta = {
    description = "CLI that let's you query your source code from a dependency graph, and validates dependencies against predefined and custom rules. It's a code architecture explorer and linter.";
    homepage = "https://tangleguard.com/apps/cli";
    license = lib.licenses.unfreeRedistributable;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ jaads ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "tangleguard-cli";
  };
}
