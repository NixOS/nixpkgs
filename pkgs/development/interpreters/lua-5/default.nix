{stdenv, fetchurl}: 

stdenv.mkDerivation {
  name = "lua-5.0.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/lua-5.0.2.tar.gz;
    md5 = "dea74646b7e5c621fef7174df83c34b1";
  };
  builder= ./builder.sh;
}
