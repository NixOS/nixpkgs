{ stdenv, fetchurl, static ? false }:

stdenv.mkDerivation rec {
  name = "zlib-1.2.6";
  
  src = fetchurl {
    urls = [ "http://www.zlib.net/${name}.tar.gz"
        "http://gentoo.netnitco.net/distfiles/${name}.tar.gz" ];
    sha256 = "06x6m33ls1606ni7275q5z392csvh18dgs55kshfnvrfal45w8r1";
  };

  patches = stdenv.lib.optional (stdenv.system == "i686-cygwin") [ ./no-shared.patch ];

  configureFlags = if static then "" else "--shared";

  preConfigure = ''
    if test -n "$crossConfig"; then
      export CC=$crossConfig-gcc
      configureFlags=${if static then "" else "--shared"}
    fi
  '';

  # As zlib takes part in the stdenv building, we don't want references
  # to the bootstrap-tools libgcc (as uses to happen on arm/mips)
  NIX_CFLAGS_COMPILE = "-static-libgcc";

  crossAttrs = {
    dontStrip = if static then true else false;
  } // (if stdenv.cross.libc == "msvcrt" then {
    configurePhase=''
      installFlags="BINARY_PATH=$out/bin INCLUDE_PATH=$out/include LIBRARY_PATH=$out/lib"
    '';
    makeFlags = [
      "-f" "win32/Makefile.gcc"
      "PREFIX=${stdenv.cross.config}-"
    ] ++ (if static then [] else [ "SHARED_MODE=1" ]);
  } else {});

  # zlib doesn't like the automatic --disable-shared from the Cygwin stdenv.
  cygwinConfigureEnableShared = true;
}
