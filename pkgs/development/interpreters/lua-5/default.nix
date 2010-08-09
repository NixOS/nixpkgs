{stdenv, fetchurl, ncurses, readline}: 

stdenv.mkDerivation {
  name = "lua-5.1.4";
  src = fetchurl {
    url = http://www.lua.org/ftp/lua-5.1.4.tar.gz;
    sha256 = "0fmgk100ficm1jbm4ga9xy484v4cm89wsdfckdybb9gjx8jy4f5h";
  };
  makeFlags = [ "CFLAGS=-fPIC" ];
  buildFlags = "linux"; # TODO: support for non-linux systems
  installFlags = "install INSTALL_TOP=\${out}";
  postInstall = ''
    sed -i -e "s@/usr/local@$out@" etc/lua.pc
    sed -i -e "s@-llua -lm@-llua -lm -ldl@" etc/lua.pc
    install -D -m 644 etc/lua.pc $out/lib/pkgconfig/lua.pc
  '';
  buildInputs = [ ncurses readline ];
}
