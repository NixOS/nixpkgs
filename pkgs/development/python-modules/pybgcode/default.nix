{boost, cmake, heatshrink, libbgcode, buildPythonPackage, zlib, pybind11, py-build-cmake, pytest, git }:

buildPythonPackage {
  inherit (libbgcode) version src meta buildInputs;
  pname = "pybgcode";
  pyproject = true;

  dontUseCmakeConfigure = true;
  patches = [
    ./0001-build-update-py-build-cmake-to-0.4.2.patch
  ];
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "options = { \"PyBGCode_LINK_SYSTEM_LIBBGCODE\" = \"off\" }" \
        "options = { \"PyBGCode_LINK_SYSTEM_LIBBGCODE\" = \"on\", \"LibBGCode_BUILD_DEPS\" = \"off\" }"
  '';

  nativeBuildInputs = [
    cmake
    git
  ];

  build-system = [
    py-build-cmake
    pytest
  ];

  propagatedBuildInputs = [
    libbgcode
    pybind11
  ];
}
