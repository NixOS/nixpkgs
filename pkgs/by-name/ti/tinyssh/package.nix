{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyssh";
  version = "20261001";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "tinyssh";
    tag = finalAttrs.version;
    hash = "sha256-z6YwIQi7BDG7W7/J3V6AX+0c3LEnwbmERUOEULUkPCY=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalistic SSH server";
    homepage = "https://tinyssh.org";
    changelog = "https://github.com/janmojzis/tinyssh/releases/tag/${finalAttrs.version}";
    license = lib.licenses.cc0;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kaction ];
  };
})
