{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libupnp-1.6.20";

  src = fetchurl {
    url = "mirror://sourceforge/pupnp/${name}.tar.bz2";
    sha256 = "0qrsdsb1qm85hc4jy04qph895613d148f0x1mmk6z99y3q43fdgf";
  };

  hardeningDisable = [ "fortify" ];

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
