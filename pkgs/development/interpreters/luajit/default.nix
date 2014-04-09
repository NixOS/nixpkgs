{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "luajit-${version}";
  version = "2.0.3";

  src = fetchurl {
    url    = "http://luajit.org/download/LuaJIT-${version}.tar.gz";
    sha256 = "0ydxpqkmsn2c341j4r2v6r5r0ig3kbwv3i9jran3iv81s6r6rgjm";
  };

  enableParallelBuilding = true;

  patchPhase = stdenv.lib.optionalString (stdenv.gcc.libc != null)
  ''
    substituteInPlace Makefile \
      --replace ldconfig ${stdenv.gcc.libc}/sbin/ldconfig
  '';

  configurePhase = false;
  buildFlags     = [ "amalg" ]; # Build highly optimized version
  installPhase   = "make install PREFIX=$out";

  meta = {
    description = "high-performance JIT compiler for Lua 5.1";
    homepage    = http://luajit.org;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
