{
  fetchurl,
  lib,
  stdenv,
  CoreServices,
}:

stdenv.mkDerivation rec {
  pname = "check";
  version = "0.15.2";

  src = fetchurl {
    url = "https://github.com/libcheck/check/releases/download/${version}/check-${version}.tar.gz";
    sha256 = "02m25y9m46pb6n46s51av62kpd936lkfv3b13kfpckgvmh5lxpm8";
  };

  # fortify breaks the libcompat vsnprintf implementation
  hardeningDisable = lib.optionals (
    stdenv.hostPlatform.isMusl && (stdenv.hostPlatform != stdenv.buildPlatform)
  ) [ "fortify" ];

  # Test can randomly fail: https://hydra.nixos.org/build/7243912
  doCheck = false;

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin CoreServices;

  meta = with lib; {
    description = "Unit testing framework for C";

    longDescription = ''
      Check is a unit testing framework for C.  It features a simple
      interface for defining unit tests, putting little in the way of the
      developer.  Tests are run in a separate address space, so Check can
      catch both assertion failures and code errors that cause
      segmentation faults or other signals.  The output from unit tests
      can be used within source code editors and IDEs.
    '';

    homepage = "https://libcheck.github.io/check/";

    license = licenses.lgpl2Plus;
    mainProgram = "checkmk";
    platforms = platforms.all;
  };
}
