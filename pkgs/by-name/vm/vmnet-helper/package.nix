{
  darwin,
  fetchFromGitHub,
  gitMinimal,
  lib,
  meson,
  ninja,
  nix-update-script,
  python3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vmnet-helper";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "nirs";
    repo = "vmnet-helper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqkikynl5QzcPwKP3KdloZ6W5F8EfZW6arpL5jQOR9w=";
  };

  nativeBuildInputs = [
    darwin.sigtool
    gitMinimal
    meson
    ninja
    (python3.withPackages (
      ps: with ps; [
        pyyaml
        scapy
      ]
    ))
  ];

  postFixup = ''
    codesign -f --entitlements $src/building/entitlements.plist -s - $out/bin/vmnet-helper
  '';

  passthru.updateScript = nix-update-script { };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "High-performance network proxy connecting VMs to macOS vmnet";
    mainProgram = "vmnet-helper";
    homepage = "https://github.com/nirs/vmnet-helper";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.quinneden ];
    platforms = lib.platforms.darwin;
  };
})
