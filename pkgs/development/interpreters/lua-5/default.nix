{stdenv, fetchurl, ncurses, readline}:

stdenv.mkDerivation {
  name = "lua-5.1.4";

  src = fetchurl {
    url = "http://www.lua.org/ftp/lua-5.1.4.tar.gz";
    sha256 = "0fmgk100ficm1jbm4ga9xy484v4cm89wsdfckdybb9gjx8jy4f5h";
  };

  NIX_CFLAGS_COMPILE = "-fPIC";
  buildFlags = if stdenv.isLinux then "linux" else
	       if stdenv.isDarwin then "macosx" else
	       if stdenv.isFreeBSD then "freebsd" else
	       if stdenv.isBSD then "bsd" else
	       "posix";
  installFlags = "install INSTALL_TOP=\${out}";
  postInstall = ''
    sed -i -e "s@/usr/local@$out@" etc/lua.pc
    sed -i -e "s@-llua -lm@-llua -lm -ldl@" etc/lua.pc
    ensureDir "$out/lib/pkgconfig"
    install -m 644 etc/lua.pc $out/lib/pkgconfig/lua.pc
  '';
  buildInputs = [ ncurses readline ];

  crossAttrs = {
    preBuild = ''
      sed -i -e "s/ gcc/$crossConfig-gcc/" \
        -e "s/ ar/$crossConfig-ar/" \
        -e "s/ ranlib/$crossConfig-ranlib/" \
        src/Makefile
    '';
  };

  meta = {
    homepage = "http://www.lua.org";
    description = "Lua is a powerful, fast, lightweight, embeddable scripting language.";
    longDescription = ''
      Lua combines simple procedural syntax with powerful data
      description constructs based on associative arrays and extensible
      semantics. Lua is dynamically typed, runs by interpreting bytecode
      for a register-based virtual machine, and has automatic memory
      management with incremental garbage collection, making it ideal
      for configuration, scripting, and rapid prototyping.
    '';
    license = "MIT";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [];
  };
}
