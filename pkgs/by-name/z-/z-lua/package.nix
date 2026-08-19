{
  lib,
  stdenv,
  fetchFromGitHub,
  lua52Packages,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "z-lua";
  version = "1.8.25";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "z.lua";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-S07YFyh6jKKQn8tpeTNReKLmpVxXzIF3jXCmst6B3+I=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ lua52Packages.lua ];

  installPhase = ''
    runHook preInstall

    install -Dm755 z.lua $out/bin/z.lua
    wrapProgram $out/bin/z.lua --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so" --set _ZL_USE_LFS 1;
    # Create symlink for backwards compatibility. See: https://github.com/NixOS/nixpkgs/pull/96081
    ln -s $out/bin/z.lua $out/bin/z

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/skywind3000/z.lua";
    description = "New cd command that helps you navigate faster by learning your habits";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "z.lua";
  };
})
