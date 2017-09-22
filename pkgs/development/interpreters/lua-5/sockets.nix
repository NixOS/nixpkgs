{ stdenv, fetchurl, lua5 }:

stdenv.mkDerivation rec {
  name    = "lua-sockets-${version}";
  version = "2.0.2";
  src = fetchurl {
      url = "http://files.luaforge.net/releases/luasocket/luasocket/luasocket-${version}/luasocket-${version}.tar.gz";
      sha256 = "19ichkbc4rxv00ggz8gyf29jibvc2wq9pqjik0ll326rrxswgnag";
  };

  luaver = lua5.luaversion;
  patchPhase = ''
      sed -e "s,^INSTALL_TOP_SHARE.*,INSTALL_TOP_SHARE=$out/share/lua/${lua5.luaversion}," \
          -e "s,^INSTALL_TOP_LIB.*,INSTALL_TOP_LIB=$out/lib/lua/${lua5.luaversion}," \
          -i config
  '';

  buildInputs = [ lua5 ];

  meta = {
    homepage = http://w3.impa.br/~diego/software/luasocket/;
    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}
