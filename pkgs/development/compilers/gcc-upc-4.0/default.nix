# Nix expression for GCC-UPC 4.0, based on that of GCC 4.0.

{ stdenv, fetchurl, noSysDirs, bison, autoconf, gnum4
, profiledCompiler ? false
, gmp ? null , mpfr ? null
, texinfo ? null
}:

with stdenv.lib;

# GCC-UPC apparently doesn't support GCov and friends.
assert profiledCompiler == false;

stdenv.mkDerivation {
  name = "gcc-upc-4.0.3.5";
  
  builder = ../gcc/4.0/builder.sh;
  
  src = fetchurl {
    url = "ftp://ftp.intrepid.com/pub/upc/rls/upc-4.0.3.5/upc-4.0.3.5.src.tar.gz";
    sha256 = "0afnz1bz0kknhl18205bbwncyza08983ivfaagj5yl7x3nwy7prv";
  };
  
  patches = [ ./honor-cflags.patch ]
    ++ optional noSysDirs [ ./no-sys-dirs.patch ];
    
  inherit noSysDirs profiledCompiler;

  # Attributes used by `wrapGCC'.
  langC   = true ;
  langCC  = false;
  langF77 = false;
  langUPC = true;    # unused

  buildInputs =
    [ gmp mpfr texinfo
      # Bison is needed to build the parsers.
      bison
      # For some reason, `autoheader' and `m4' are needed.
      autoconf gnum4
    ];

  # Note: We use `--enable-maintainer-mode' so that `bison' is actually
  # run when needed.
  configureFlags = "
    --disable-multilib
    --disable-libstdcxx-pch
    --disable-libmudflap
    --with-system-zlib
    ${if stdenv.isi686 then "--with-arch=i686" else ""}
    --enable-maintainer-mode
  ";

  meta = {
    homepage = http://www.intrepid.com/upc.html;
    license = "GPL/LGPL";
    longDscription = ''
      A GCC-based compiler for the Unified Parallel C (UPC) language,
      a distributed shared memory aware variant of C (see
      http://upc.gwu.edu/).
    '';
  };
}
