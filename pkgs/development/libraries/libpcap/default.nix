{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  name = "libpcap-1.2.1";
  
  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "1gfy00zv6blplw3405q46khmjhdnp6ylblvygjjjk5skgvpscdd1";
  };
  
  buildNativeInputs = [ flex bison ];
  
  configureFlags = "--with-pcap=linux";

  preInstall = ''mkdir -p $out/bin'';
  
  crossAttrs = {
    # Stripping hurts in static libraries
    dontStrip = true;
    configureFlags = [ "--with-pcap=linux" "ac_cv_linux_vers=2" ];
  };

  meta = {
    homepage = http://www.tcpdump.org;
    description = "Packet Capture Library";
  };
}
