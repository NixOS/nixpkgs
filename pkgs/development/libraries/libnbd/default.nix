{ lib
, stdenv
, fetchurl
, bash-completion
, pkg-config
, perl
, buildPythonBindings ? false, python3
, libxml2
, fuse
, fuse3
, gnutls
}:

stdenv.mkDerivation rec {
  pname = "libnbd";
  version = "1.20.2";

  src = fetchurl {
    url = "https://download.libguestfs.org/libnbd/${lib.versions.majorMinor version}-stable/${pname}-${version}.tar.gz";
    hash = "sha256-7DgviwGPPLccTPvomyH+0CMknXmR2wENsxpXD97OP84=";
  };

  nativeBuildInputs = [
    bash-completion
    pkg-config
    perl
  ]
    ++ lib.optionals buildPythonBindings [ python3 ];

  buildInputs = [
    fuse
    fuse3
    gnutls
    libxml2
  ];

  configureFlags = lib.optionals buildPythonBindings [ "--with-python-installdir=${placeholder "out"}/${python3.sitePackages}" ];

  installFlags = [ "bashcompdir=$(out)/share/bash-completion/completions" ];

  postInstall = lib.optionalString buildPythonBindings ''
    LIBNBD_PYTHON_METADATA='${placeholder "out"}/${python3.sitePackages}/nbd-${version}.dist-info/METADATA'
    install -Dm644 -T ${./libnbd-metadata} $LIBNBD_PYTHON_METADATA
    substituteAllInPlace $LIBNBD_PYTHON_METADATA
  '';

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
# TODO: bindings for go and ocaml
