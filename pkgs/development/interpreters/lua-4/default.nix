{stdenv, fetchurl}: 

stdenv.mkDerivation {
  name = "lua-4.0.1";
  src = fetchurl {
    url = http://www.lua.org/ftp/lua-4.0.1.tar.gz;
    md5 = "a31d963dbdf727f9b34eee1e0d29132c";
  };
  builder= ./builder.sh;
}
