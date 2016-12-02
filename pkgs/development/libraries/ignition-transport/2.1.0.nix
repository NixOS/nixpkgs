{ stdenv, fetchurl, cmake, pkgconfig, protobuf, zeromq, cppzmq, utillinux
, tools, messages, math2 } :

stdenv.mkDerivation rec {
  version = "2.1.0";
  name = "ign-transport2-${version}";
  src = fetchurl {
    url = "http://gazebosim.org/distributions/ign-transport/releases/ignition-transport2-${version}.tar.bz2";
    sha256 = "0bi1pknj1676rlr49nh40pqfkr4g9jpzr3ijhf82p5l0m3k0w6gi";
  };
  buildInputs = [ cmake protobuf zeromq pkgconfig tools messages math2 ]
    ++ stdenv.lib.optional stdenv.isLinux utillinux;
  propagatedBuildInputs = [ cppzmq ];
  postPatch = ''
    substituteInPlace cmake/ignition-config.cmake.in --replace "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_" "@CMAKE_INSTALL_"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/ignition-config.cmake.in --replace "if (NOT uuid_FOUND)" "if (FALSE)"
    substituteInPlace cmake/SearchForStuff.cmake \
      --replace "pkg_check_modules(uuid uuid)" "" \
      --replace "if (NOT uuid_FOUND)" "if (FALSE)"
  '';
  meta = with stdenv.lib; {
    homepage = http://ignitionrobotics.org/libraries/transport;
    description = "Combines ZeroMQ with Protobufs to create a fast and efficient message passing system";
    license = licenses.asl20;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
