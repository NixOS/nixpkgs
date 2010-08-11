{ stdenv, fetchurl, libxml2, gnutls, devicemapper, perl, python }:

let version = "0.8.3"; in

stdenv.mkDerivation {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/libvirt-${version}.tar.gz";
    sha256 = "07vsk4g1nxvxc8yr6cdvwp9kvwgm2g7lh6aaggfkxb2775n87q9m";
  };

  buildInputs = [ libxml2 gnutls devicemapper perl python ];

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
