{ fetchurl, stdenv
, CoreServices
}:

stdenv.mkDerivation rec {
  name = "check-${version}";
  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/libcheck/check/releases/download/${version}/check-${version}.tar.gz";
    sha256 = "0d22h8xshmbpl9hba9ch3xj8vb9ybm5akpsbbh7yj07fic4h2hj6";
  };

  # Test can randomly fail: http://hydra.nixos.org/build/7243912
  doCheck = false;

  buildInputs = stdenv.lib.optional stdenv.isDarwin CoreServices;

  meta = with stdenv.lib; {
    description = "Unit testing framework for C";

    longDescription =
      '' Check is a unit testing framework for C.  It features a simple
         interface for defining unit tests, putting little in the way of the
         developer.  Tests are run in a separate address space, so Check can
         catch both assertion failures and code errors that cause
         segmentation faults or other signals.  The output from unit tests
         can be used within source code editors and IDEs.
      '';

    homepage = https://libcheck.github.io/check/;

    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
