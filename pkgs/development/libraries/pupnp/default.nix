{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libupnp-1.6.6";

  src = fetchurl {
    url = "mirror://sourceforge/pupnp/${name}.tar.bz2";
    sha256 = "1cxvn0v8lcc5p70jc3j50a7rm12am6xr0l2fibi8075jqazcmmsq";
  };

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
  };
}
