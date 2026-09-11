{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  stdenv,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "syntax";
  version = "0.1.27";
  src = fetchFromGitHub {
    owner = "DmitrySoshnikov";
    repo = "syntax";
    rev = "v${version}";
    hash = "sha256-5ZbelnZQvJ9k4GbWR+lDEgxXGLt4VsXput9nBV8nUdc=";
  };

  npmDepsHash = "sha256-jZwbRGGg4tek6Jr+V7/SceJlsbIv7jFWQ+qa+fnChTw=";

  dontCheckForBrokenSymlinks = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/DmitrySoshnikov/syntax";
    description = "Syntactic analysis toolkit, language-agnostic parser generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
    mainProgram = "syntax-cli";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
