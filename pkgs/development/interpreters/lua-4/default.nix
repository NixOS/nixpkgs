{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lua-4.0.1";

  src = fetchurl {
    url = http://www.lua.org/ftp/lua-4.0.1.tar.gz;
    sha256 = "0ajd906hasii365xdihv9mdmi3cixq758blx0289x4znkha6wx6z";
  };

  configurePhase = "sed -i -e 's/CFLAGS= -O2/CFLAGS = -O3 -fPIC/' config";
  buildFlags = "all so sobin";
  installFlags = "INSTALL_ROOT=$$out";

  hardeningDisable = stdenv.lib.optional stdenv.isi686 "stackprotector";

  meta = {
    homepage = http://www.lua.org;
    description = "Powerful, fast, lightweight, embeddable scripting language";
    longDescription = ''
      Lua combines simple procedural syntax with powerful data
      description constructs based on associative arrays and extensible
      semantics. Lua is dynamically typed, runs by interpreting bytecode
      for a register-based virtual machine, and has automatic memory
      management with incremental garbage collection, making it ideal
      for configuration, scripting, and rapid prototyping.
    '';
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    branch = "4";
  };
}
