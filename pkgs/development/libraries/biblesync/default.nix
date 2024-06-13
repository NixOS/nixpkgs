{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, libuuid }:

stdenv.mkDerivation rec {

  pname = "biblesync";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "karlkleinpaste";
    repo = "biblesync";
    rev = version;
    sha256 = "0prmd12jq2cjdhsph5v89y38j7hhd51dr3r1hivgkhczr3m5hf4s";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ libuuid ];

  meta = with lib; {
    homepage = "https://wiki.crosswire.org/BibleSync";
    description = "Multicast protocol to Bible software shared conavigation";
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
    platforms = lib.platforms.linux;
  };
}
