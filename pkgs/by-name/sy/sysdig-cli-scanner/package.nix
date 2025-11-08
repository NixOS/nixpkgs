{
  stdenv,
  lib,
  fetchurl,
  writeShellScript,
}:
let
  versionMetadata = import ./sysdig-cli-scanner.versions.nix;
  fetchForSystem = versionMetadata.${stdenv.system} or (throw "unsupported system ${stdenv.system}");

  wrapper = writeShellScript "sysdig-cli-scanner-wrapper" ''
    for arg in "$@"; do
      # We must not pass --dbpath to the cli in case it has been called with --iac
      # IaC Scanning does not make use of the vulnerability database
      if [ "$arg" = "--iac" ]; then
        exec @out@/libexec/sysdig-cli-scanner-unwrapped "$@"
      fi
    done

    # --dbpath argument is needed for vulnerability scanning mode, otherwise it tries to download
    # the vulnerability database in the same path as the binary, which is read-only in the case of the
    # nix store
    exec @out@/libexec/sysdig-cli-scanner-unwrapped \
      --dbpath="$HOME/.cache/sysdig-cli-scanner/" "$@"
  '';
in
stdenv.mkDerivation {
  pname = "sysdig-cli-scanner";
  version = versionMetadata.version;

  src = fetchurl { inherit (fetchForSystem) url hash; };
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -T $src $out/libexec/sysdig-cli-scanner-unwrapped
    install -Dm755 -T ${wrapper} $out/bin/sysdig-cli-scanner
    substituteInPlace $out/bin/sysdig-cli-scanner --subst-var out

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
