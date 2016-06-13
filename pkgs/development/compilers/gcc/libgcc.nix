{ stdenv, gcc, glibc }:

stdenv.mkDerivation rec {
  name = "libgcc-${version}";
  version = gcc.cc.version;
  arch = "x86_64-unknown-linux-gnu";
  path = "${gcc.cc}/lib/gcc/${arch}/${version}";

  buildCommand = ''
    mkdir -p "$out/lib"

    cp -r ${path}/libgcc.a $out/lib
    cp -r ${path}/crtbegin.o $out/lib
    cp -r ${path}/crtbeginS.o $out/lib
    cp -r ${path}/crtbeginT.o $out/lib
    cp -r ${path}/crtendS.o $out/lib
    cp -r ${path}/crtend.o $out/lib

    cp -r ${path}/crtfastmath.o $out/lib
    cp -r ${path}/crtprec32.o $out/lib
    cp -r ${path}/crtprec80.o $out/lib
    cp -r ${path}/crtprec64.o $out/lib
    cp -r ${path}/libgcc_eh.a $out/lib

    cp -r ${glibc.out}/lib/libgcc_s.so.1 $out/lib/libgcc_s.so
  '';
}
