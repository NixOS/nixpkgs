{ stdenv, fetchurl, cmake }:

let
  version = "2.3.0";
in
stdenv.mkDerivation rec {
  name = "ign-math2-${version}";

  src = fetchurl {
    url = "http://gazebosim.org/distributions/ign-math/releases/ignition-math2-${version}.tar.bz2";
    sha256 = "1a2jgq6allcxg62y0r61iv4hgxkfr1whpsxy75hg7k85s7da8dpl";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = http://ignitionrobotics.org/libraries/math;
    description = "Math library by Ingition Robotics, created for the Gazebo project";
    license = licenses.asl20;
    maintainers = with maintainers; [ therealpxc ];
    platforms = platforms.all;
  };
}
