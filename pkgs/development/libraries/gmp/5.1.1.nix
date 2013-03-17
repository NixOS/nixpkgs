{ stdenv, fetchurl, m4, cxx ? true }:

stdenv.mkDerivation rec {
  name = "gmp-5.1.1";

  src = fetchurl {
    urls = [ "mirror://gnu/gmp/${name}.tar.xz" "ftp://ftp.gmplib.org/pub/${name}/${name}.tar.xz" ];
    sha256 = "1hili06lcf0clg5qfvz7knm6pmj6ab54yhsvskp1mdny5xw4vmjb";
  };

  nativeBuildInputs = [ m4 ];

  configureFlags =
    # Build a "fat binary", with routines for several sub-architectures
    # (x86), except on Solaris where some tests crash with "Memory fault".
    # See <http://hydra.nixos.org/build/2760931>, for instance.
    (stdenv.lib.optional (!stdenv.isSunOS) "--enable-fat")
    ++ (if cxx then [ "--enable-cxx" ] else [ "--disable-cxx" ])
    ++ (if stdenv.is64bit then [ "--with-pic" ] else []);

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "http://gmplib.org/";
    description = "GMP, the GNU multiple precision arithmetic library";
    license = stdenv.lib.licenses.gpl3Plus;

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

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
  };
}
