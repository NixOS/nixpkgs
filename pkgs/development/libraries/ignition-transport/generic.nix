{ stdenv, fetchurl, cmake, pkgconfig, utillinux,
  protobuf, zeromq, cppzmq,
  version, src    # parametrize version and src so we can easily have pkgs
                  # for different versions
  , ...
}:

stdenv.mkDerivation rec {
  name = "ign-transport-${version}";
  inherit src;

  buildInputs = [ cmake protobuf zeromq pkgconfig
    utillinux # we need utillinux/e2fsprogs uuid/uuid.h
  ];

  propagatedBuildInputs = [ cppzmq ];

  postPatch = ''
    substituteInPlace cmake/ignition-config.cmake.in --replace "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_" "@CMAKE_INSTALL_"
  '';

  meta = with stdenv.lib; {
    homepage = http://ignitionrobotics.org/libraries/math;
    description = "Math library by Ingition Robotics, created for the Gazebo project";
    license = licenses.asl20;
    maintainers = with maintainers; [ pxc ];
    platforms = platforms.all;
  };
}
