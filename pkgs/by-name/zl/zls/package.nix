{
  lib,
  stdenv,
  zig_0_14,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zls";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-A5Mn+mfIefOsX+eNBRHrDVkqFDVrD3iXDNsUL4TPhKo=";
  };

  nativeBuildInputs = [ zig_0_14.hook ];

  zigDeps = zig_0_14.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-5ub+AA2PYuHrzPfouii/zfuFmQfn6mlMw4yOUDCw3zI=";
  };

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
