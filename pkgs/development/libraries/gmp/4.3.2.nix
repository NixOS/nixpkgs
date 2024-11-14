{
  lib,
  stdenv,
  fetchurl,
  m4,
  cxx ? true,
}:

let
  self = stdenv.mkDerivation rec {
    pname = "gmp";
    version = "4.3.2";

    src = fetchurl {
      url = "mirror://gnu/gmp/gmp-${version}.tar.bz2";
      sha256 = "0x8prpqi9amfcmi7r4zrza609ai9529pjaq0h4aw51i867064qck";
    };

    #outputs TODO: split $cxx due to libstdc++ dependency
    # maybe let ghc use a version with *.so shared with rest of nixpkgs and *.a added
    # - see #5855 for related discussion
    outputs = [
      "out"
      "dev"
      "info"
    ];
    passthru.static = self.out;

    nativeBuildInputs = [ m4 ];

    # Prevent the build system from using sub-architecture-specific
    # instructions (e.g., SSE2 on i686).
    #
    # This is not a problem for Apple machines, which are all alike.  In
    # addition, `configfsf.guess' would return `i386-apple-darwin10.2.0' on
    # `x86_64-darwin', leading to a 32-bit ABI build, which is undesirable.
    preConfigure =
      if !stdenv.hostPlatform.isDarwin then
        "ln -sf configfsf.guess config.guess"
      else
        ''echo "Darwin host is `./config.guess`."'';

    configureFlags =
      [
        (lib.enableFeature cxx "cxx")
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "ac_cv_build=x86_64-apple-darwin13.4.0"
        "ac_cv_host=x86_64-apple-darwin13.4.0"
      ];

    # The test t-lucnum_ui fails (on Linux/x86_64) when built with GCC 4.8.
    # Newer versions of GMP don't have that issue anymore.
    doCheck = false;

    meta = {
      branch = "4";
      description = "GNU multiple precision arithmetic library";

      longDescription = ''
        GMP is a free library for arbitrary precision arithmetic, operating
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

      homepage = "https://gmplib.org/";
      license = lib.licenses.lgpl3Plus;

      maintainers = [ ];
      platforms = lib.platforms.all;
      badPlatforms = [ "x86_64-darwin" ];
      # never built on aarch64-darwin, aarch64-linux since first introduction in nixpkgs
      broken =
        (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)
        || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    };
  };
in
self
