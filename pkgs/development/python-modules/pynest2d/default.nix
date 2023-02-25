{ lib, buildPythonPackage, fetchFromGitHub, python, cmake
, libnest2d, sip, clipper, conan, pkg-config, j2cli }:


let withConanCMakeDeps = conan.withConanCMakeDepsFile;
in
buildPythonPackage rec {
  version = "5.1.0";
  pname = "pynest2d";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "pynest2d";
    rev = version;
    sha256 = "sha256-ye5SJUt0WCI2z/kYt7kOQSeqlsaDz/L0Tq4DTAiUPuo=";
  };

  propagatedBuildInputs = [
    (withConanCMakeDeps {package = libnest2d; lib_search="nest2d_clipper_nlopt";})
    sip
    (withConanCMakeDeps {package = clipper; pkg_name = "clipper"; lib_search="polyclipping";})
  ];
  nativeBuildInputs = [ cmake pkg-config sip j2cli ];

  cmakeFlags = [
    "-DPython_SITELIB_LOCAL=${python.sitePackages}"
    #"-DPython_SITEARCH=${placeholder "out"}/${python.sitePackages}"
    "-DBUILD_SHARED_LIBS=ON"
    "-DLIBNEST2D_HEADER_ONLY=OFF"
  ];

  CLIPPER_PATH = "${clipper.out}";

  postPatch = ''
    sed -i '2i include(CMakePackageConfigHelpers)' CMakeLists.txt
    sed -i '2i find_package(PkgConfig)' CMakeLists.txt
    sed -i '2i include(GenerateExportHeader)' CMakeLists.txt
     sed -i 's|find_package(cpython ''${Python_VERSION} REQUIRED)|pkg_check_modules(python REQUIRED IMPORTED_TARGET python)|' CMakeLists.txt
    sed -i 's|cpython::cpython|PkgConfig::python|g' CMakeLists.txt
     sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python.sitePackages}#' cmake/SIPMacros.cmake


    mkdir -p build/pynest2d/
    module_name=pynest2d sip_dir=$(pwd)/src sip_include_dirs=$(pwd)/src build_dir=$(pwd)/build/pynest2d/ \
      j2 pyproject.toml.jinja -o pyproject.toml
    ln -s cmake/CMakeBuilder.py CMakeBuilder.py
    sip-build --pep484-pyi --no-protected-is-public
   '';

  meta = with lib; {
    description = "Python bindings for libnest2d";
    homepage = "https://github.com/Ultimaker/pynest2d";
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
