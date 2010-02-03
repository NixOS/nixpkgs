{ stdenv, fetchurl, libxml2, gnutls, devicemapper, perl }:

let version = "0.7.5"; in

stdenv.mkDerivation {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/libvirt-${version}.tar.gz";
    sha256 = "922481aadf72a74cf14012fe3967c60d01e70f7e88908410d57428943ab4eb8b";
  };

  buildInputs = [ libxml2 gnutls devicemapper perl ];

  # fix for redhat bz 531496
  patches = [ ./non-absolute-ld.patch ];

  # xen currently disabled in nixpkgs
  configureFlags = ''                                                  
    --without-xen
  '';
  
  meta = {
    homepage = http://libvirt.org/;
    description = "A toolkit to interact with the virtualization capabilities of recent versions of Linux (and other OSes).";
    license = "LGPLv2+";
  };
}
