{
  lib,
  stdenv,
  zig_0_15,
  fetchFromGitHub,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zls";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-GFzSHUljcxy7sM1PaabbkQUdUnLwpherekPWJFxXtnk=";
  };

  nativeBuildInputs = [ zig_0_15.hook ];

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
