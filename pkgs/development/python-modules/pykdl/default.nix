{ lib, stdenv, toPythonModule, fetchpatch, cmake, orocos-kdl, python, sip }:

toPythonModule (stdenv.mkDerivation {
  pname = "pykdl";
  inherit (orocos-kdl) version src;

  patches = [
    # Fix build with SIP 4.19.23+. Can be removed with version 1.5.
    # https://github.com/orocos/orocos_kinematics_dynamics/pull/270
    (fetchpatch {
      url = "https://github.com/orocos/orocos_kinematics_dynamics/commit/d8d087ad0e1c41f3489d1a255ebfa27b5695196b.patch";
      sha256 = "0qyskqxv4a982kidzzyh34xj2iiw791ipbbl29jg4qb4l21xwqlg";
      stripLen = 1;
    })
  ];

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
