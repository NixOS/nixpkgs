{ stdenv, fetchurl, readline }:

let
  dsoPatch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/lua-arch.patch?h=packages/lua51";
    sha256 = "11fcyb4q55p4p7kdb8yp85xlw8imy14kzamp2khvcyxss4vw8ipw";
    name = "lua-arch.patch";
  };
in
stdenv.mkDerivation rec {
  name = "lua-5.1.5";

  src = fetchurl {
    url = "http://www.lua.org/ftp/${name}.tar.gz";
    sha256 = "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333";
  };

  buildInputs = [ readline ];

  patches = [ dsoPatch ];

  configurePhase = ''
    makeFlagsArray=( INSTALL_TOP=$out INSTALL_MAN=$out/share/man/man1 PLAT=linux CFLAGS="-DLUA_USE_LINUX -O2 -fPIC" LDLAGS="-fPIC" )
    installFlagsArray=( TO_BIN="lua luac" TO_LIB="liblua.a liblua.so liblua.so.5.1 liblua.so.5.1.5" INSTALL_DATA='cp -d' )
  '';

  postInstall = ''
    mkdir -p "$out/share/doc/lua" "$out/lib/pkgconfig"
    sed <"etc/lua.pc" >"$out/lib/pkgconfig/lua.pc" -e "s|^prefix=.*|prefix=$out|"
    mv "doc/"*.{gif,png,css,html} "$out/share/doc/lua/"
    rmdir $out/{share,lib}/lua/5.1 $out/{share,lib}/lua
  '';

  meta = {
    homepage = "http://www.lua.org";
    description = "Powerful, fast, lightweight, embeddable scripting language";
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
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
