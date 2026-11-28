{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "trustedcoin";
  version = "0.8.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nbd-wtf";
    repo = "trustedcoin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mi+sri+N/EFXGm5JwNIAV+oXS0joOY5vef8FrKPmn7A=";
  };

  vendorHash = "sha256-fW+EoNPC0mH8C06Q6GXNwFdzE7oQT+qd+B7hGGml+hc=";

  # Not needed on any particular platform; trustedcoin has no cgo code. Matches
  # upstream's Makefile and gives a static binary without glibc in its closure.
  env.CGO_ENABLED = 0;

  # Drop the Go symbol table and DWARF info (~0.7 MB smaller), which the
  # default strip -S in fixupPhase leaves in place.
  ldflags = [
    "-s"
    "-w"
  ];

  # main_test.go spawns ./trustedcoin and speaks the plugin JSON-RPC over stdio
  preCheck = ''
    ln -s "$GOPATH/bin/trustedcoin" .
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Core Lightning plugin that replaces bitcoind with trusted public explorers";
    homepage = "https://github.com/nbd-wtf/trustedcoin";
    changelog = "https://github.com/nbd-wtf/trustedcoin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prusnak
      seberm
    ];
    mainProgram = "trustedcoin";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
