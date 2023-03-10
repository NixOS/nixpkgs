{ stdenv
, config
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, libusb1
, ninja
, pkg-config
, gcc
, mesa
, gtk3
, glfw
, libGLU
, curl
, cudaSupport ? config.cudaSupport or false, cudaPackages ? {}
, enablePython ? false, pythonPackages ? null
, enableGUI ? false,
}:

assert cudaSupport -> (cudaPackages?cudatoolkit && cudaPackages.cudatoolkit != null);
assert enablePython -> pythonPackages != null;

stdenv.mkDerivation rec {
  pname = "librealsense";
  version = "2.45.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aqf48zl7825v7x8c3x5w4d17m4qq377f1mn6xyqzf9b0dnk4i1j";
  };

  buildInputs = [
    libusb1
    gcc.cc.lib
  ] ++ lib.optional cudaSupport cudaPackages.cudatoolkit
    ++ lib.optionals enablePython (with pythonPackages; [ python pybind11 ])
    ++ lib.optionals enableGUI [ mesa gtk3 glfw libGLU curl ];

  patches = [
    # fix build on aarch64-darwin
    # https://github.com/IntelRealSense/librealsense/pull/9253
    (fetchpatch {
      url = "https://github.com/IntelRealSense/librealsense/commit/beb4c44debc8336de991c983274cad841eb5c323.patch";
      sha256 = "05mxsd2pz3xrvywdqyxkwdvxx8hjfxzcgl51897avz4v2j89pyq8";
    })
    ./py_sitepackage_dir.patch
    ./py_pybind11_no_external_download.patch
  ];

  postPatch = ''
    # https://github.com/IntelRealSense/librealsense/issues/11092
    # insert a "#include <iostream" at beginning of file
    sed '1i\#include <iostream>' -i wrappers/python/pyrs_device.cpp
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=ON"
    "-DBUILD_GRAPHICAL_EXAMPLES=${lib.boolToString enableGUI}"
    "-DBUILD_GLSL_EXTENSIONS=${lib.boolToString enableGUI}"
    "-DCHECK_FOR_UPDATES=OFF" # activated by BUILD_GRAPHICAL_EXAMPLES, will make it download and compile libcurl
  ] ++ lib.optionals enablePython [
    "-DBUILD_PYTHON_BINDINGS:bool=true"
    "-DXXNIX_PYTHON_SITEPACKAGES=${placeholder "out"}/${pythonPackages.python.sitePackages}"
  ] ++ lib.optional cudaSupport "-DBUILD_WITH_CUDA:bool=true";

  # ensure python package contains its __init__.py. for some reason the install
  # script does not do this, and it's questionable if intel knows it should be
  # done
  # ( https://github.com/IntelRealSense/meta-intel-realsense/issues/20 )
  postInstall = lib.optionalString enablePython  ''
    cp ../wrappers/python/pyrealsense2/__init__.py $out/${pythonPackages.python.sitePackages}/pyrealsense2
  '';

  meta = with lib; {
    description = "A cross-platform library for Intel® RealSense™ depth cameras (D400 series and the SR300)";
    homepage = "https://github.com/IntelRealSense/librealsense";
    license = licenses.asl20;
    maintainers = with maintainers; [ brian-dawn pbsds ];
    platforms = platforms.unix;
  };
}
