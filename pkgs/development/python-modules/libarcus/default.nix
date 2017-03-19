{ stdenv, lib, fetchFromGitHub, python, cmake, sip, protobuf }:

if lib.versionOlder python.version "3.4.0"
then throw "libArcus not supported for interpreter ${python.executable}"
else

stdenv.mkDerivation rec {
  name = "libarcus-${version}";
  version = "2.4.0";
  
  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "07lf5d42pnx0h9lgldplfdj142rbcsxx23njdblnq04di7a4937h";
  };
  
  propagatedBuildInputs = [ sip protobuf ];
  nativeBuildInputs = [ cmake ];

  postPatch = ''
    # To workaround buggy SIP detection which overrides PYTHONPATH
    sed -i '/SET(ENV{PYTHONPATH}/d' cmake/FindSIP.cmake
  '';

  meta = with stdenv.lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://github.com/Ultimaker/libArcus";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
