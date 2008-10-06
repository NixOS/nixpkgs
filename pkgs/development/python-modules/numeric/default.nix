{ fetchurl, stdenv, python }:

let version = "24.2"; in
  stdenv.mkDerivation {
    name = "python-numeric-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/numpy/Numeric-${version}.tar.gz";
      sha256 = "0n2jy47n3d121pky4a3r0zjmk2vk66czr2x3y9179xbgxclyfwjz";
    };

    buildInputs = [ python ];

    buildPhase   = ''python setup.py build --build-base "$out"'';
    installPhase = ''
      python setup.py install --prefix "$out"

      # Remove the `lib.linux-i686-2.5' and `temp.linux-i686-2.5' (or
      # similar) directories.
      rm -rf $out/lib.* $out/temp.*
    '';

    # FIXME: Run the tests.

    meta = {
      description = "Numeric, a Python module for high-performance, numeric computing";

      longDescription = ''
        Numeric is a Python module for high-performance, numeric
        computing.  It provides much of the functionality and
        performance of commercial numeric software such as Matlab; it
        some cases, it provides more functionality than commercial
        software.
      '';

      license = "Python+LLNL";

      homepage = http://people.csail.mit.edu/jrennie/python/numeric/;
    };
  }