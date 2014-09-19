{ stdenv, fetchurl, lua5_1, unzip, sqlite }:

stdenv.mkDerivation rec {
  version = "2.1.1";
  name = "lua-sqlite3-${version}";
  isLibrary = true;
  src = fetchurl {
    url = "https://github.com/LuaDist/luasql-sqlite3/archive/2acdb6cb256e63e5b5a0ddd72c4639d8c0feb52d.zip";
    sha256 = "1yy1n1l1801j48rlf3bhxpxqfgx46ixrs8jxhhbf7x1hn1j4axlv";
  };

  buildInputs = [ unzip lua5_1 sqlite ];

  preBuild = ''
    makeFlagsArray=(
      PREFIX=$out
      LUA_LIBDIR="$out/lib/lua/${lua5_1.luaversion}"
      LUA_INC="-I${lua5_1}/include");
  '';

  patches = [ ./luasql.patch ];

  meta = {
    homepage = "https://github.com/LuaDist/luasql-sqlite3";
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
