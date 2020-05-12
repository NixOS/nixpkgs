{ stdenv, fetchFromGitHub, pkgconfig, cmake, libuuid }:

stdenv.mkDerivation rec {

  pname = "biblesync";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "karlkleinpaste";
    repo = "biblesync";
    rev = version;
    sha256 = "1baq2fwf6132i514xrvq05p2gy98mkg1rn5whf9q5k475q81nrlr";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ libuuid ];

  meta = with stdenv.lib; {
    homepage = "http://www.crosswire.org/wiki/BibleSync";
    description = "A multicast protocol to Bible software shared conavigation";
    longDescription = ''
      BibleSync is a multicast protocol to support Bible software shared
      co-navigation. It uses LAN multicast in either a personal/small team
      mutual navigation motif or in a classroom environment where there are
      Speakers plus the Audience. The library implementing the protocol is a
      single C++ class providing a complete yet minimal public interface to
      support mode setting, setup for packet reception, transmit on local
      navigation, and handling of incoming packets.
    '';
    license = licenses.publicDomain;
    maintainers = [ maintainers.AndersonTorres ]; 
    platforms = stdenv.lib.platforms.linux;
  };
}
