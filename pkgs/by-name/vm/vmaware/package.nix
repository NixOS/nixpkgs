{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vmaware";
  version = "2.8.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NotRequiem";
    repo = "VMAware";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hSnN3GIowHbL+SEgsnx1jr7busZ9BPw38ODhSw9lw6I=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform C++ library and CLI tool for virtual machine detection";
    homepage = "https://github.com/NotRequiem/VMAware";
    changelog = "https://github.com/NotRequiem/VMAware/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ patrickdag ];
    platforms = lib.platforms.linux;
    mainProgram = "vmaware";
  };
})
