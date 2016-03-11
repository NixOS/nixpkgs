{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "luajit-${version}";
  version = "2.0.4";

  src = fetchurl {
    url    = "http://luajit.org/download/LuaJIT-${version}.tar.gz";
    sha256 = "0zc0y7p6nx1c0pp4nhgbdgjljpfxsb5kgwp4ysz22l1p2bms83v2";
  };

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace Makefile \
      --replace /usr/local $out

    substituteInPlace src/Makefile --replace gcc cc
  '' + stdenv.lib.optionalString (stdenv.cc.libc != null)
  ''
    substituteInPlace Makefile \
      --replace ldconfig ${stdenv.cc.libc.bin or stdenv.cc.libc}/bin/ldconfig
  '';

  configurePhase = false;
  buildFlags     = [ "amalg" ]; # Build highly optimized version
  installPhase   = "make install PREFIX=$out";

  meta = with stdenv.lib; {
    description = "high-performance JIT compiler for Lua 5.1";
    homepage    = http://luajit.org;
    license     = licenses.mit;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
