{ stdenv, fetchurl, cmake, pkgconfig, protobuf, math2 } :

stdenv.mkDerivation rec {
  name = "ign-msgs-${version}";
  version = "0.6.0";
  src = fetchurl {
    url = "https://bitbucket.org/ignitionrobotics/ign-msgs/get/ignition-msgs_0.6.0.tar.gz";
    sha256 = "0akm7a0n5qfz24n3xsh68dm2m7lc5sj6cpg5j95sg10ixc77f232";
  };
  buildInputs = [ cmake pkgconfig protobuf math2 ];
  postPatch = ''
    substituteInPlace cmake/ignition-config.cmake.in --replace "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_" "@CMAKE_INSTALL_"
  '';
  meta = with stdenv.lib; {
    homepage = http://ignitionrobotics.org/libraries/messages;
    description = "Standard set of message definitions, used by Ignition Transport, and other applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
