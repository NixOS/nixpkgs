{stdenv, fetchurl, ncurses, readline}: 

stdenv.mkDerivation {
  name = "lua-5.1.2";
  src = fetchurl {
    url = http://www.lua.org/ftp/lua-5.1.2.tar.gz;
    sha256 = "17ixifwgjva5592s2rn1ki56wa7hgw0z210r4bcx5lv8zv39iw2w";
  };
  buildFlags = "linux"; # TODO: support for non-linux systems
  installFlags = "install INSTALL_TOP=\${out}";
  buildInputs = [ ncurses readline ];
}
