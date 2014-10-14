{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  name = "libpcap-1.5.3";
  
  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "14wyjywrdi1ikaj6yc9c72m6m2r64z94lb0gm7k1a3q6q5cj3scs";
  };
  
  nativeBuildInputs = [ flex bison ];
  
  # Apparently, 32 bit systems need this forced? Not verified if still needed.
  configureFlags = stdenv.lib.optionals (stdenv.system == "i686-linux") "--with-pcap=linux";

  preInstall = ''mkdir -p $out/bin'';
  
  crossAttrs = {
    # Stripping hurts in static libraries
    dontStrip = true;
    configureFlags = configureFlags ++ [ "ac_cv_linux_vers=2" ];
  };

  meta = {
    homepage = http://www.tcpdump.org;
    description = "Packet Capture Library";
  };
}
