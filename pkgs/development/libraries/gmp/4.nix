{stdenv, fetchurl, m4, cxx ? true, static ? false}:

let
  staticFlags = if static then " --enable-static --disable-shared" else "";
in

stdenv.mkDerivation rec {
  name = "gmp-4.3.2";

  src = fetchurl {
    url = "mirror://gnu/gmp/${name}.tar.bz2";
    sha256 = "0x8prpqi9amfcmi7r4zrza609ai9529pjaq0h4aw51i867064qck";
  };

  buildNativeInputs = [m4];

  # Prevent the build system from using sub-architecture-specific
  # instructions (e.g., SSE2 on i686).
  preConfigure = "ln -sf configfsf.guess config.guess";

  configureFlags = (if cxx then "--enable-cxx" else "--disable-cxx") +
      staticFlags;

  dontDisableStatic = if static then true else false;


  doCheck = true;

  meta = {
    description = "GMP, the GNU multiple precision arithmetic library";

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

    homepage = http://gmplib.org/;
    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
