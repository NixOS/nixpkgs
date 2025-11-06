{
  lib,
  stdenv,
  toPythonModule,
  cmake,
  pybind11,
  orocos-kdl,
  eigen,
  python,
}:

toPythonModule (
  stdenv.mkDerivation {
    pname = "pykdl";
    inherit (orocos-kdl) version src;

    sourceRoot = "${orocos-kdl.src.name}/python_orocos_kdl";

    # Fix hardcoded installation path
    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace dist-packages site-packages
    '';

    nativeBuildInputs = [
      cmake
      pybind11
    ];
    buildInputs = [
      orocos-kdl
      eigen
    ];
    propagatedBuildInputs = [ python ];

    cmakeFlags = [ "-DPYTHON_EXECUTABLE=${lib.getExe python.pythonOnBuildForHost}" ];

    meta = with lib; {
      description = "Kinematics and Dynamics Library (Python bindings)";
      homepage = "https://www.orocos.org/kdl.html";
      license = licenses.lgpl21Only;
      maintainers = with maintainers; [ lopsided98 ];
      platforms = platforms.all;
    };
  }
)
