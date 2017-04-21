{ stdenv, fetchurl, cmake, pkgconfig, ruby } :

stdenv.mkDerivation {
  name = "ign-tools-20160808";
  src = fetchurl {
    url = "https://bitbucket.org/ignitionrobotics/ign-tools/get/75a248c4c899.tar.gz";
    sha256 = "1njwi1j9h2qqm949ix2pm3mgm6a9isd3r5xpv9yv9v3z6kp43c31";
  };
  buildInputs = [ cmake pkgconfig ruby ];
  postPatch = ''
    substituteInPlace cmake/ignition-config.cmake.in --replace "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_" "@CMAKE_INSTALL_"
  '';
  meta = with stdenv.lib; {
    homepage = http://ignitionrobotics.org/libraries/tools;
    description = "Umbrella CLI tool for individual Ingition Robotics projects";
    license = licenses.asl20;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
