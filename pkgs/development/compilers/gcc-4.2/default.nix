{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, staticCompiler ? false
}:

assert langC;

with import ../../../lib;

stdenv.mkDerivation {
  name = "gcc-4.2.2";
  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = mirror://gnu/gcc/gcc-4.2.2/gcc-core-4.2.2.tar.bz2;
      sha256 = "01hdwd4im2xzg159fk022zqyhlxphqvpmabd25bqb8fjbs2yi80a";
    }) ++
    optional /*langCC*/ true (fetchurl {
      url = mirror://gnu/gcc/gcc-4.2.2/gcc-g++-4.2.2.tar.bz2;
      sha256 = "04xankxi3bi4gvgv8rq9h6w3bdx59bg9zh0zv6lyw373gy26ygmq";
    }) ++
    optional langF77 (fetchurl {
      url = mirror://gnu/gcc/gcc-4.2.2/gcc-fortran-4.2.2.tar.bz2;
      sha256 = "1fybl88w0l99cqppx18i6hnq5dsrssx3qd7vr2ybmmk3nfx8pziq";
    });
    
  patches =
    [./pass-cxxcpp.patch]
    ++ optional noSysDirs [./no-sys-dirs.patch];
    
  inherit noSysDirs profiledCompiler staticCompiler;

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
