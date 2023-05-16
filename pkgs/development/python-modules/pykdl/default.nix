{ lib, stdenv, toPythonModule, cmake, orocos-kdl, eigen, python }:

toPythonModule (stdenv.mkDerivation {
  pname = "pykdl";
  inherit (orocos-kdl) version src;

<<<<<<< HEAD
  sourceRoot = "${orocos-kdl.src.name}/python_orocos_kdl";
=======
  sourceRoot = "source/python_orocos_kdl";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Fix hardcoded installation path
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace dist-packages site-packages
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ orocos-kdl eigen ];
  propagatedBuildInputs = [ python ];

  meta = with lib; {
    description = "Kinematics and Dynamics Library (Python bindings)";
    homepage = "https://www.orocos.org/kdl.html";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
})
