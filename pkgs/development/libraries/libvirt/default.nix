{ stdenv, fetchurl, libxml2, gnutls, devicemapper, perl, python }:

let version = "0.8.8"; in

stdenv.mkDerivation {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/libvirt-${version}.tar.gz";
    sha256 = "04z1757qpi3ssnjv5h2qnw1sds2m50yxk67cbdam6w4i50vyl2h3";
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
    platforms = stdenv.lib.platforms.linux;
  };
}
