{ stdenv, fetchurl, pkgconfig, cmake, libuuid }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "biblesync-${version}";
  version = "1.1.2";

  src = fetchurl{
    url = "mirror://sourceforge/project/gnomesword/BibleSync/1.1.2/${name}.tar.gz";
    sha256 = "0190q2da0ppif2242lahl8xfz01n9sijy60aq1a0545qcp0ilvl8";
  };

  buildInputs = [ pkgconfig cmake libuuid ];

  meta = {
    homepage = http://www.crosswire.org/wiki/BibleSync;
    description = "A multicast protocol to Bible software shared conavigation";
    longDescription = ''
      BibleSync is a multicast protocol to support Bible software
      shared co-navigation. It uses LAN multicast in either a
      personal/small team mutual navigation motif or in a classroom
      environment where there are Speakers plus the Audience. The
      library implementing the protocol is a single C++ class
      providing a complete yet minimal public interface to support
      mode setting, setup for packet reception, transmit on local
      navigation, and handling of incoming packets.
    '';
    license = licenses.publicDomain;
    maintainers = [ maintainers.AndersonTorres ]; 
  };
}
