{
  darwin,
  fetchFromGitHub,
  git,
  lib,
  meson,
  ninja,
  nix-update-script,
  python3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vmnet-helper";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "nirs";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-wn9vZQA2BbjIwPjkiykr1nhzNnKoSjbbd2NNcbHMaxw=";
  };

  nativeBuildInputs = [
    darwin.sigtool
    git
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
    codesign -f --entitlements $src/entitlements.plist -s - $out/bin/vmnet-helper
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance network proxy connecting VMs to macOS vmnet";
    mainProgram = "vmnet-helper";
    homepage = "https://github.com/nirs/vmnet-helper";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.quinneden ];
    platforms = lib.platforms.darwin;
  };
})
