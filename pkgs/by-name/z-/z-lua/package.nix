{
  lib,
  stdenv,
  fetchFromGitHub,
  lua55Packages,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "z-lua";
  version = "1.8.26";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "z.lua";
    tag = finalAttrs.version;
    hash = "sha256-ohcBKf/m8vnypXVFm+09YbwAgA6BQkPB/Objnt/tZpw=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ lua55Packages.lua ];

  installPhase = ''
    runHook preInstall

    install -Dm755 z.lua $out/bin/z.lua
    wrapProgram $out/bin/z.lua --set LUA_CPATH "${lua55Packages.getLuaCPath lua55Packages.luafilesystem}" --set _ZL_USE_LFS 1;
    # Create symlink for backwards compatibility. See: https://github.com/NixOS/nixpkgs/pull/96081
    ln -s $out/bin/z.lua $out/bin/z

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/skywind3000/z.lua";
    description = "New cd command that helps you navigate faster by learning your habits";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naderhaj ];
    mainProgram = "z.lua";
  };
})
