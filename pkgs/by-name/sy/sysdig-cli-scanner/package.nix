{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
}:
let
  versionMetadata = import ./sysdig-cli-scanner.versions.nix;
  fetchForSystem = versionMetadata.${stdenv.system} or (throw "unsupported system ${stdenv.system}");
in
stdenv.mkDerivation {
  pname = "sysdig-cli-scanner";
  version = versionMetadata.version;

  src = fetchurl { inherit (fetchForSystem) url hash; };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -T $src $out/bin/sysdig-cli-scanner

    wrapProgram $out/bin/sysdig-cli-scanner \
      --add-flags --dbpath="\$HOME/.cache/sysdig-cli-scanner/"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Tool for scanning container images and directories using Sysdig";
    longDescription = ''
      The Sysdig Vulnerability CLI Scanner, sysdig-cli-scanner, is a versatile tool designed to
      manually scan container images and directories, whether they are located locally or remotely.
      Depending on your specific use case, you have the flexibility to execute sysdig-cli-scanner
      in Vulnerability Management (VM) mode for image scanning or Infrastructure as Code (IaC) mode
      for scanning directories.
    '';
    homepage = "https://docs.sysdig.com/en/docs/installation/sysdig-secure/install-vulnerability-cli-scanner/";
    mainProgram = "sysdig-cli-scanner";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ tembleking ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
