{ stdenv, fetchurl, lua5 }:

stdenv.mkDerivation {
  version = "1.6.2";
  pname = "lua-filesystem";
  isLibrary = true;
  src = fetchurl {
    url = "https://github.com/keplerproject/luafilesystem/archive/v1_6_2.tar.gz";
    sha256 = "1n8qdwa20ypbrny99vhkmx8q04zd2jjycdb5196xdhgvqzk10abz";
  };

  buildInputs = [ lua5 ];

  preBuild = ''
    makeFlagsArray=(
      PREFIX=$out
      LUA_LIBDIR="$out/lib/lua/${lua5.luaversion}"
      LUA_INC="-I${lua5}/include");
  '';

  meta = {
    homepage = https://github.com/keplerproject/luafilesystem;
    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
