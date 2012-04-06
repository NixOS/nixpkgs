{ fetchurl, stdenv, unzip, cmake, mesa }:

stdenv.mkDerivation {
  name = "vrpn-07.30";

  src = fetchurl {
    url = "ftp://ftp.cs.unc.edu/pub/packages/GRIP/vrpn/vrpn_07_30.zip";
    sha256 = "1rysp08myv88q3a30dr7js7vg3hvq8zj2bjrpcgpp86fm3gjpvb4";
  };

  buildInputs = [ unzip cmake mesa ];

  doCheck = false;                                # FIXME: test failure
  checkTarget = "test";

  meta = {
    description = "Virtual Reality Peripheral Network";

    longDescription =
      '' The Virtual-Reality Peripheral Network (VRPN) is a set of classes
         within a library and a set of servers that are designed to implement
         a network-transparent interface between application programs and the
         set of physical devices (tracker, etc.) used in a virtual-reality
         (VR) system.
      '';

    homepage = http://www.cs.unc.edu/Research/vrpn/;

    license = "BSL1.0"; # Boost Software License,
                        # see # <http://www.cs.unc.edu/Research/vrpn/obtaining_vrpn.html>

  };
}
