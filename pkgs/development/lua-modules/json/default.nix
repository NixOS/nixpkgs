{
  buildLuaPackage,
  fetchFromGitHub,
  lib,
  lua,
}:

buildLuaPackage rec {
  pname = "json";
  version = "0.1.2";
  src = fetchFromGitHub {
    owner = "rxi";
    repo = "json.lua";
    rev = "v${version}";
    hash = "sha256-JSKMxF5NSHW3QaELFPWm1sx7kHmOXEPsUkM3i/px7Gk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/lua/${lua.luaversion}
    cp -r json.lua $out/share/lua/${lua.luaversion}

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/rxi/json.lua";
    description = "A lightweight JSON library for Lua";
    license = lib.licenses.mit;
  };
}
