{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  abseil-cpp,
  pybind11,
  python,
}:

buildPythonPackage rec {
  pname = "pybind11-abseil";
  version = "202402.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11_abseil";
    rev = "v${version}";
    hash = "sha256-hFVuGzEFqAEm2p2RmfhFtLB6qOqNuVNcwcLh8dIWi0k=";
  };

  patches = [
    (fetchpatch {
      name = "pybind11_abseil.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11-abseil/pybind11_abseil.patch?rev=2";
      hash = "sha256-zwxCIhYMvexdSUmKM22OMBMEo0NRDgMtSVMDySFCn6U=";
    })
    (fetchpatch {
      name = "use-system-packages-if-possible.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11-abseil/use-system-packages-if-possible.patch?rev=2";
      hash = "sha256-CLHOSni2ej6ICtvMtBoCIpR9CNPPibwIS+hYbOCAwBE=";
    })
    (fetchpatch {
      name = "0001-Install-headers-and-CMake-development-files.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/pybind11-abseil/0001-Install-headers-and-CMake-development-files.patch?rev=2";
      hash = "sha256-TU9AzvF83aROY4gwys2ITOcdtjEm4x2IbhX4cHNWp0M=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    abseil-cpp
    pybind11
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_PYDIR" "${placeholder "out"}/${python.sitePackages}")
    (lib.cmakeFeature "Python_EXECUTABLE" python.interpreter)
  ];

  meta = {
    description = "Pybind11 bindings for the Abseil C++ Common Libraries";
    homepage = "https://github.com/pybind/pybind11_abseil";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
