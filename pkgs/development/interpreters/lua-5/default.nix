{stdenv, fetchurl, ncurses, readline}: 

stdenv.mkDerivation {
  name = "lua-5.1.4";
  src = fetchurl {
    url = http://www.lua.org/ftp/lua-5.1.4.tar.gz;
    sha256 = "0fmgk100ficm1jbm4ga9xy484v4cm89wsdfckdybb9gjx8jy4f5h";
  };
  makeFlags = [ "MYCFLAGS=-fPIC" ];
  buildFlags = "linux"; # TODO: support for non-linux systems
  installFlags = "install INSTALL_TOP=\${out}";
  buildInputs = [ ncurses readline ];
}
