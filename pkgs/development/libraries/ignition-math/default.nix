{ stdenv, fetchurl, cmake }:

let
  version = "2.6.0";
in
stdenv.mkDerivation {
  pname = "ign-math2";
  inherit version;

  src = fetchurl {
    url = "http://gazebosim.org/distributions/ign-math/releases/ignition-math2-${version}.tar.bz2";
    sha256 = "1d4naq0zp704c7ckj2wwmhplxmwkvcs1jib8bklnnd09lhg9j92j";
  };

  buildInputs = [ cmake ];
  preConfigure = ''
    cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_INCLUDEDIR=include -DCMAKE_INSTALL_LIBDIR=lib"
  '';

  meta = with stdenv.lib; {
    homepage = https://ignitionrobotics.org/libraries/math;
    description = "Math library by Ingition Robotics, created for the Gazebo project";
    license = licenses.asl20;
    maintainers = with maintainers; [ pxc ];
    platforms = platforms.all;
  };
}
