{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lua-5.0.3";

  src = fetchurl {
    url = http://www.lua.org/ftp/lua-5.0.3.tar.gz;
    sha256 = "1193a61b0e08acaa6eee0eecf29709179ee49c71baebc59b682a25c3b5a45671";
  };

  configurePhase = "sed -i -e 's/MYCFLAGS=.*/MYCFLAGS=-O3 -fomit-frame-pointer -fPIC/' config";
  buildFlags = "all so sobin";
  installFlags = "INSTALL_ROOT=$$out";
  installTargets = "install soinstall";

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
