{ pkgs, stdenv, fetchurl, lua5_1, zziplib }:

stdenv.mkDerivation rec {
  version = "1.2.3";
  name = "lua-zip-${version}";
  isLibrary = true;
  src = fetchurl {
    url = "https://github.com/luaforge/luazip/archive/0b8f5c958e170b1b49f05bc267bc0351ad4dfc44.zip";
    sha256 = "beb9260d606fdd5304aa958d95f0d3c20be7ca0a2cff44e7b75281c138a76a50";
  };

  buildInputs = [ pkgs.unzip lua5_1 zziplib ];

  preBuild = ''
    makeFlagsArray=(
      PREFIX=$out
      LUA_LIBDIR="$out/lib/lua/${lua5_1.luaversion}"
      LUA_INC="-I${lua5_1}/include");
  '';

  patches = [ ./zip.patch ];

  meta = {
    homepage = https://github.com/luaforge/luazip;
    hydraPlatforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}
