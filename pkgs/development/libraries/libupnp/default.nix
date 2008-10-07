{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libupnp-1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/upnp/${name}.tar.gz";
    sha256 = "0zbng3zk4br70l8snn765nf89pmkw7wdh8gf6vxmf9r2099nl3ad";
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

    homepage = http://upnp.sourceforge.net/;
  };
}
