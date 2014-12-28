{ fetchurl, stdenv }:

let version = "0.9.14"; in
stdenv.mkDerivation {
  name = "check-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/check/${version}/check-${version}.tar.gz";
    sha256 = "02l4g79d81s07hzywcv1knwj5dyrwjiq2pgxaz7kidxi8m364wn2";
  };

  # Test can randomly fail: http://hydra.nixos.org/build/7243912
  doCheck = false;

  meta = {
    description = "Unit testing framework for C";

    longDescription =
      '' Check is a unit testing framework for C.  It features a simple
         interface for defining unit tests, putting little in the way of the
         developer.  Tests are run in a separate address space, so Check can
         catch both assertion failures and code errors that cause
         segmentation faults or other signals.  The output from unit tests
         can be used within source code editors and IDEs.
      '';

    homepage = http://check.sourceforge.net/;

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
