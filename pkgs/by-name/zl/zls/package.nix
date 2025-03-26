{
  lib,
  stdenv,
  zig_0_14,
  fetchFromGitHub,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zls";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-A5Mn+mfIefOsX+eNBRHrDVkqFDVrD3iXDNsUL4TPhKo=";
  };

  nativeBuildInputs = [ zig_0_14.hook ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "Zig LSP implementation + Zig Language Server";
    mainProgram = "zls";
    changelog = "https://github.com/zigtools/zls/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/zigtools/zls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      moni
      _0x5a4
    ];
    platforms = lib.platforms.unix;
  };
})
