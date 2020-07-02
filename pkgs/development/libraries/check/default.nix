{ fetchurl, stdenv
, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "check";
  version = "0.15.0";

  src = fetchurl {
    url = "https://github.com/libcheck/check/releases/download/${version}/check-${version}.tar.gz";
    sha256 = "0q5cs6rqbq8a1m9ij3dxnsjcs31mvg0b2i77g0iykqd6iz3f78mf";
  };

  # Test can randomly fail: https://hydra.nixos.org/build/7243912
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

    homepage = "https://libcheck.github.io/check/";

    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
