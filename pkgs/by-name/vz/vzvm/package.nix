{
  lib,
  fetchFromGitHub,
  darwin,
  swift,
  swiftPackages,
  nix-update-script,
}:

swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "vzvm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "applicative-systems";
    repo = "vzvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wAozYULlBYelKH5Z35uOWm6nzu9gpMCV6G5WhWL8GKk=";
  };

  sourceRoot = "${finalAttrs.src.name}/vzvm";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    darwin.sigtool
    swift
  ];

  # No external deps: avoids need for swiftpm2nix and `swift build` (network fetches)
  buildPhase = ''
    runHook preBuild

    swiftc -O -o vzvm Sources/vzvm/*.swift

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 vzvm $out/bin/vzvm

    runHook postInstall
  '';

  # Virtualization.framework can't create VMs without this entitlement
  postFixup = ''
    codesign --entitlements ${finalAttrs.src}/vzvm/vzvm.entitlements -f -s - $out/bin/vzvm
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal Linux VM monitor built on Apple's Virtualization.framework";
    longDescription = ''
      vzvm boots a Linux guest from a kernel and initrd on Apple's
      Virtualization.framework, configured from a JSON file. It supports
      Rosetta directory shares for running x86_64 binaries on Apple silicon, and
      forwards host TCP ports into the guest over vsock, so inbound connections need
      no guest IP discovery. Highly specialized for use as linux-builder.
    '';
    homepage = "https://github.com/applicative-systems/vzvm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tfc ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "vzvm";
  };
})
