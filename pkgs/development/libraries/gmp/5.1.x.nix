{ stdenv, fetchurl, m4, cxx ? true, withStatic ? true }:

with { inherit (stdenv.lib) optional; };

stdenv.mkDerivation rec {
  name = "gmp-5.1.3";

  src = fetchurl { # we need to use bz2, others aren't in bootstrapping stdenv
    urls = [ "mirror://gnu/gmp/${name}.tar.bz2" "ftp://ftp.gmplib.org/pub/${name}/${name}.tar.bz2" ];
    sha256 = "0q5i39pxrasgn9qdxzpfbwhh11ph80p57x6hf48m74261d97j83m";
  };

  nativeBuildInputs = [ m4 ];

  patches = if stdenv.isDarwin then [ ./need-size-t.patch ] else null;

  configureFlags =
    # Build a "fat binary", with routines for several sub-architectures
    # (x86), except on Solaris where some tests crash with "Memory fault".
    # See <http://hydra.nixos.org/build/2760931>, for instance.
    #
    # no darwin because gmp uses ASM that clang doesn't like
    optional (!stdenv.isSunOS) "--enable-fat"
    ++ (if cxx then [ "--enable-cxx"  ]
               else [ "--disable-cxx" ])
    ++ optional (cxx && stdenv.isDarwin) "CPPFLAGS=-fexceptions"
    ++ optional stdenv.isDarwin "ABI=64"
    ++ optional stdenv.is64bit "--with-pic"
    ;

  doCheck = true;

  dontDisableStatic = withStatic;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://gmplib.org/";
    description = "GNU multiple precision arithmetic library";
    license = licenses.gpl3Plus;

    longDescription =
      '' GMP is a free library for arbitrary precision arithmetic, operating
         on signed integers, rational numbers, and floating point numbers.
         There is no practical limit to the precision except the ones implied
         by the available memory in the machine GMP runs on.  GMP has a rich
         set of functions, and the functions have a regular interface.

         The main target applications for GMP are cryptography applications
         and research, Internet security applications, algebra systems,
         computational algebra research, etc.

         GMP is carefully designed to be as fast as possible, both for small
         operands and for huge operands.  The speed is achieved by using
         fullwords as the basic arithmetic type, by using fast algorithms,
         with highly optimised assembly code for the most common inner loops
         for a lot of CPUs, and by a general emphasis on speed.

         GMP is faster than any other bignum library.  The advantage for GMP
         increases with the operand sizes for many operations, since GMP uses
         asymptotically faster algorithms.
      '';

    platforms = platforms.all;
    maintainers = [ maintainers.simons ];
  };
}
