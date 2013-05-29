{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  name = "libpcap-1.4.0";
  
  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "01klphfqxvkyjvic0hmc10qmiicqz6pv6kvb9s00kaz8f57jlskw";
  };
  
  nativeBuildInputs = [ flex bison ];
  
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
