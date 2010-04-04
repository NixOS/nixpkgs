{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  name = "libpcap-1.1.0";
  
  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "073hy17pvm203c0z3zpkp1b37sblcgf49c6a03az7kbniizbc07b";
  };
  
  buildNativeInputs = [ flex bison ];
  
  configureFlags = "--with-pcap=linux";

  preInstall = ''ensureDir $out/bin'';
  
  patches = [ ./libpcap_amd64.patch ];

  crossAttrs = {
    # Stripping hurts in static libraries
    dontStrip = true;
    configureFlags = [ "--with-pcap=linux" "ac_cv_linux_vers=2" ];
  };
}
