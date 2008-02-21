{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, staticCompiler ? false
, texinfo ? null
}:

assert langC;

with import ../../../lib;

stdenv.mkDerivation {
  name = "gcc-4.2.0";
  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = mirror://gnu/gcc/gcc-4.2.0/gcc-core-4.2.0.tar.bz2;
      sha256 = "0ykhzxhr8857dr97z0j9wyybfz1kjr71xk457cfapfw5fjas4ny1";
    }) ++
    optional /*langCC*/ true (fetchurl {
      url = mirror://gnu/gcc/gcc-4.2.0/gcc-g++-4.2.0.tar.bz2;
      sha256 = "0k5ribrfdp9vmljxrglcgx2j2r7xnycd1rvd8sny2y5cj0l8ps12";
    }) ++
    optional langF77 (fetchurl {
      url = mirror://gnu/gcc/gcc-4.2.0/gcc-fortran-4.2.0.tar.bz2;
      sha256 = "0vw07qv6qpa5cgxc0qxraq6li2ibh8zrp65jrg92v4j63ivvi3hh";
    });
    
  patches =
    [./pass-cxxcpp.patch]
    ++ optional noSysDirs [./no-sys-dirs.patch];
    
  inherit noSysDirs profiledCompiler staticCompiler;

  buildInputs = []
    ++ optional (texinfo != null) [texinfo];

  configureFlags = "
    --disable-multilib
    --disable-libstdcxx-pch
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC   "c"
        ++ optional langCC  "c++"
        ++ optional langF77 "f77"
        )
      )
    }
    ${if stdenv.isi686 then "--with-arch=i686" else ""}
  ";

  makeFlags = if staticCompiler then "LDFLAGS=-static" else "";

  passthru = { inherit langC langCC langF77; };

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.2.x";
  };
}
