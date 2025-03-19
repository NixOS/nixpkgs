{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyssh";
  version = "20250201";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "tinyssh";
    tag = finalAttrs.version;
    hash = "sha256-HX531QjRrDG4dshqzR03naZptUYnoZLEdv/CGpKOaD0=";
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
