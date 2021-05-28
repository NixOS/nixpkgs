{ lib, stdenv, toPythonModule, cmake, orocos-kdl, python, sip }:

toPythonModule (stdenv.mkDerivation {
  pname = "pykdl";
  inherit (orocos-kdl) version src;

  sourceRoot = "source/python_orocos_kdl";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ orocos-kdl ];
  propagatedBuildInputs = [ python sip ];

  meta = with lib; {
    description = "Kinematics and Dynamics Library (Python bindings)";
    homepage = "https://www.orocos.org/kdl.html";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
})
