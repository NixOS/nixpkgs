{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  pam,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "term39";
  version = "1.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "alejandroqh";
    repo = "term39";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LyrlbxiFBpnCkzOtgASX1WKrJ1BajaXdOsJJEO9Cq18=";
  };

  cargoHash = "sha256-TSSUetkXACBLxou5CXsmpGLKuY9fEFYGbGmhBcm9JQY=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pam
  ];

  meta = {
    description = "Modern, retro-styled terminal multiplexer with a classic MS-DOS aesthetic";
    homepage = "https://github.com/alejandroqh/term39";
    changelog = "https://github.com/alejandroqh/term39/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alejandroqh ];
    mainProgram = "term39";
    platforms = lib.platforms.linux;
  };
})
