{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, profiledCompiler ? false
, staticCompiler ? false
, gmp ? null
, mpfr ? null
, texinfo ? null
, name ? "gcc"
}:

with stdenv.lib;

let version = "4.2.4"; in

stdenv.mkDerivation {
  name = "${name}-${version}";
  
  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "0cm5yzhqhgdfk03aayakmdj793sya42xkkqhslj7s2b697hygjfg";
    }) ++
    optional langCC (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "0gq8ikci0qqgck71qqlhfld6zkwn9179x6z15vdd9blkdig55nxg";
    }) ++
    optional langFortran (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-fortran-${version}.tar.bz2";
      sha256 = "013yqiqhdavgxzjryvylgf3lcnknmw89fx41jf2v4899srn0bhkg";
    });
    
  patches =
    [./pass-cxxcpp.patch]
    ++ optional noSysDirs [./no-sys-dirs.patch];
    
  inherit noSysDirs profiledCompiler staticCompiler;

  buildInputs = [gmp mpfr texinfo];

  configureFlags = "
    --disable-multilib
    --disable-libstdcxx-pch
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC       "c"
        ++ optional langCC      "c++"
        ++ optional langFortran "fortran"
        )
      )
    }
    ${if stdenv.isi686 then "--with-arch=i686" else ""}
  ";

  NIX_EXTRA_LDFLAGS = if staticCompiler then "-static" else "";

  passthru = { inherit langC langCC langFortran; };

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.2.x";
  };
}
