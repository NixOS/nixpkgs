{ lib
, stdenv
, fetchurl
, fetchpatch
, bash-completion
, pkg-config
, perl
, libxml2
, fuse
, fuse3
, gnutls
}:

stdenv.mkDerivation rec {
  pname = "libnbd";
  version = "1.18.1";

  src = fetchurl {
    url = "https://download.libguestfs.org/libnbd/${lib.versions.majorMinor version}-stable/${pname}-${version}.tar.gz";
    hash = "sha256-UNHRphDw1ycRnp0KClzHlSuLIxs5Mc4gcjB+EF/smbY=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-5871.patch";
      url = "https://gitlab.com/nbdkit/libnbd/-/commit/4451e5b61ca07771ceef3e012223779e7a0c7701.patch";
      hash = "sha256-zmg/kxSJtjp2w9917Sp33ezt7Ccj/inngzCUVesF1Tc=";
    })
  ];

  nativeBuildInputs = [
    bash-completion
    pkg-config
    perl
  ];

  buildInputs = [
    fuse
    fuse3
    gnutls
    libxml2
  ];

  installFlags = [ "bashcompdir=$(out)/share/bash-completion/completions" ];

  meta = with lib; {
    homepage = "https://gitlab.com/nbdkit/libnbd";
    description = "Network Block Device client library in userspace";
    longDescription = ''
      NBD — Network Block Device — is a protocol for accessing Block Devices
      (hard disks and disk-like things) over a Network.  This is the NBD client
      library in userspace, a simple library for writing NBD clients.

      The key features are:
      - Synchronous API for ease of use.
      - Asynchronous API for writing non-blocking, multithreaded clients. You
        can mix both APIs freely.
      - High performance.
      - Minimal dependencies for the basic library.
      - Well-documented, stable API.
      - Bindings in several programming languages.
      - Shell (nbdsh) for command line and scripting.
    '';
    license = with licenses; lgpl21Plus;
    maintainers = with maintainers; [ AndersonTorres humancalico ];
    platforms = with platforms; linux;
  };
}
# TODO: package the 1.6-stable version too
# TODO: git version needs ocaml
# TODO: bindings for go, ocaml and python

