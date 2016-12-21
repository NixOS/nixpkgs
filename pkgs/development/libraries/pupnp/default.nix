{ fetchzip, stdenv }:

stdenv.mkDerivation rec {
  name = "libupnp-1.6.21";

  # TODO: use proper source, but it's not available for now.
  src = fetchzip {
    url = "https://sourceforge.net/code-snapshots/git/p/pu/pupnp/code.git/pupnp-code-07c03def31d7d8fc6c04646a28432a580a3b2d85.zip";
    sha256 = "07ksfhadinaa20542gblrxi9pqz0v6y70a836hp3qr4037id4nm9";
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
