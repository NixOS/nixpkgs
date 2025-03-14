{
  lib,
  stdenv,
  toPythonModule,
  fetchpatch,
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

    patches = [
      # Support system pybind11; the vendored copy doesn't support Python 3.11
      (fetchpatch {
        url = "https://github.com/orocos/orocos_kinematics_dynamics/commit/e25a13fc5820dbca6b23d10506407bca9bcdd25f.patch";
        hash = "sha256-NGMVGEYsa7hVX+SgRZgeSm93BqxFR1uiyFvzyF5H0Y4=";
        stripLen = 1;
      })
    ];

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
