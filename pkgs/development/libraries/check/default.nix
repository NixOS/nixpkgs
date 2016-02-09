{ fetchurl, stdenv
, CoreServices
}:

stdenv.mkDerivation rec {
  name = "check-${version}";
  version = "0.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/check/${version}/check-${version}.tar.gz";
    sha256 = "0lhhywf5nxl3dd0hdakra3aasl590756c9kmvyifb3vgm9k0gxgm";
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

    homepage = http://check.sourceforge.net/;

    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
