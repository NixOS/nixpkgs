{ stdenv, fetchurl, m4, cxx ? true }:

stdenv.mkDerivation (rec {
  name = "gmp-5.0.3";

  src = fetchurl {
    url = "mirror://gnu/gmp/${name}.tar.bz2";
    sha256 = "dcafe9989c7f332b373e1f766af8e9cd790fc802fdec422a1910a6ef783480e3";
  };

  buildNativeInputs = [ m4 ];

  configureFlags =
    # Build a "fat binary", with routines for several sub-architectures (x86).
    [ "--enable-fat" ]
    ++ (if cxx then [ "--enable-cxx" ] else [ "--disable-cxx" ]);

  doCheck = true;

  enableParallelBuilding = true;

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

    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.all;
  };
}

//

(if stdenv.isFreeBSD
 then {
   # On FreeBSD, GMP's `config.guess' detects the sub-architecture (e.g.,
   # "k8") and generates code specific to that sub-architecture, in spite of
   # `--enable-fat', leading to illegal instructions and similar errors on
   # machines with a different sub-architecture.
   # See <http://hydra.nixos.org/build/2269915/nixlog/1/raw>, for an example.
   # Thus, use GNU's standard `config.guess' so that it assumes the generic
   # architecture (e.g., "x86_64").
   preConfigure =
     '' rm config.guess && ln -s configfsf.guess config.guess
        chmod +x configfsf.guess
     '';
 }
 else { }))
