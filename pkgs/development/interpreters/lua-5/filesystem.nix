{ stdenv, fetchgit, lua5 }:

stdenv.mkDerivation rec {
  name = "lua-filesystem-${version}";
  version = "95573506c5b92d2fdc32b162a3ad86d2da8d4f15";
  src = fetchgit {
    url = https://github.com/keplerproject/luafilesystem;
    rev = version;
    sha256 = "6e24d1ddd6c576485b1bcd8c0bc9708f04649ff326629f6b4063214fadda9614";
  };

  buildPhase = '' make LUA_INC="${lua5}/include" PREFIX=$out '';
  installPhase = '' make LUA_INC="${lua5}/include" PREFIX=$out install '';
  
  meta = {
    homepage = http://keplerproject.github.io/luafilesystem/;
    description = "LuaFileSystem is a Lua library developed to complement the set of functions related to file systems offered by the standard Lua distribution.";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.bennofs ];
  };
}