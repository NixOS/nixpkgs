{ stdenv, fetchurl, lua5, lua5_sockets, openssl }:

stdenv.mkDerivation rec {
  version = "0.5";
  name = "lua-sec-${version}";
  src = fetchurl {
    url = "https://github.com/brunoos/luasec/archive/luasec-${version}.tar.gz";
    sha256 = "08rm12cr1gjdnbv2jpk7xykby9l292qmz2v0dfdlgb4jfj7mk034";
  };

  buildInputs = [ lua5 openssl ];

  preBuild = ''
    makeFlagsArray=(
      linux
      LUAPATH="$out/lib/lua/${lua5.luaversion}"
      LUACPATH="$out/lib/lua/${lua5.luaversion}"
      INC_PATH="-I${lua5}/include"
      LIB_PATH="-L$out/lib");
  '';

  meta = {
    homepage = "https://github.com/brunoos/luasec";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.flosse ];
  };
}
