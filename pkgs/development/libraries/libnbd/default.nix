{ lib
, stdenv
, fetchurl
, bash-completion
, pkg-config
, perl
, libxml2
, fuse
, gnutls
}:

stdenv.mkDerivation rec {
  pname = "libnbd";
  version = "1.7.2";

  src = fetchurl {
    url = "https://download.libguestfs.org/libnbd/${lib.versions.majorMinor version}-development/${pname}-${version}.tar.gz";
    hash = "sha256-+xC4wDEeWi3RteF04C/qjMmjM+lmhtrtXZZyM1UUli4=";
  };

  nativeBuildInputs = [
    bash-completion
    pkg-config
    perl
  ];
  buildInputs = [
    fuse
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
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
# TODO: NBD URI support apparently is not enabled
# TODO: package the 1.6-stable version too
# TODO: git version needs ocaml
# TODO: bindings for go, ocaml and python

