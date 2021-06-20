{ stdenv, config, lib, fetchFromGitHub, cmake, libusb1, ninja, pkg-config, gcc
, cudaSupport ? config.cudaSupport or false, cudatoolkit
, enablePython ? false, pythonPackages ? null }:

assert cudaSupport -> cudatoolkit != null;
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
  ] ++ lib.optional cudaSupport cudatoolkit
    ++ lib.optionals enablePython (with pythonPackages; [python pybind11 ]);

  patches = lib.optionals enablePython [
    ./py_sitepackage_dir.patch
    ./py_pybind11_no_external_download.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=ON"
    "-DBUILD_GRAPHICAL_EXAMPLES=OFF"
    "-DBUILD_GLSL_EXTENSIONS=OFF"
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
    maintainers = with maintainers; [ brian-dawn ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
