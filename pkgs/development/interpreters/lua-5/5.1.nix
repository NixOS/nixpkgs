{ stdenv, fetchurl, readline}:

stdenv.mkDerivation rec {
  name = "lua-5.1.5";

  src = fetchurl {
    url = "http://www.lua.org/ftp/${name}.tar.gz";
    sha256 = "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333";
  };

  buildInputs = [ readline ];

  configurePhase = "makeFlagsArray=( INSTALL_TOP=$out INSTALL_MAN=$out/share/man/man1 PLAT=linux )";

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
    maintainers = [ ];
  };
}
