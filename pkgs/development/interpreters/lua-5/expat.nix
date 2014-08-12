{ stdenv, fetchurl, lua5, expat }:

stdenv.mkDerivation rec {
  version = "1.3.0";
  name = "lua-expat-${version}";
  isLibrary = true;
  src = fetchurl {
    url = "https://matthewwild.co.uk/projects/luaexpat/luaexpat-${version}.tar.gz";
    sha256 = "1hvxqngn0wf5642i5p3vcyhg3pmp102k63s9ry4jqyyqc1wkjq6h";
  };

  buildInputs = [ lua5 expat ];

  preBuild = ''
    makeFlagsArray=(
      LUA_LDIR="$out/share/lua/${lua5.luaversion}"
      LUA_INC="-I${lua5}/include" LUA_CDIR="$out/lib/lua/${lua5.luaversion}"
      EXPAT_INC="-I${expat}/include");
  '';

  meta = {
    homepage = "http://matthewwild.co.uk/projects/luaexpat";
    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.flosse ];
  };
}
