{ fetchFromGitHub, stdenv, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "libupnp-${version}";
  version = "1.6.20";

  src = fetchFromGitHub {
    owner = "mrjimenez";
    repo = "pupnp";
    rev = "release-${version}";
    sha256 = "10583dkz1l5sjp2833smql8w428x2nbh1fni8j6h9rji6ma2yhs0";
  };

  buildInputs = [
    autoconf
    automake
    libtool
  ];

  hardeningDisable = [ "fortify" ];

  preConfigure = ''
    ./bootstrap
  '';

  meta = {
    description = "libupnp, an open source UPnP development kit for Linux";

    longDescription = ''
      The Linux SDK for UPnP Devices (libupnp) provides developers
      with an API and open source code for building control points,
      devices, and bridges that are compliant with Version 1.0 of the
      UPnP Device Architecture Specification.
    '';

    license = "BSD-style";

    homepage = http://pupnp.sourceforge.net/;
    platforms = stdenv.lib.platforms.unix;
  };
}
