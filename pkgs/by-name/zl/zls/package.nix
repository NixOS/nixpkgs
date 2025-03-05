{ lib
, stdenv
, fetchFromGitHub
, zig_0_13
, callPackage
, apple-sdk_11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zls";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-vkFGoKCYUk6B40XW2T/pdhir2wzN1kpFmlLcoLwJx1U=";
  };

  zigBuildFlags = [
    "-Dversion_data_path=${zig_0_13.src}/doc/langref.html.in"
  ];

  nativeBuildInputs = [ zig_0_13.hook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "Zig LSP implementation + Zig Language Server";
    mainProgram = "zls";
    changelog = "https://github.com/zigtools/zls/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/zigtools/zls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda moni _0x5a4 ];
    platforms = lib.platforms.unix;
  };
})
