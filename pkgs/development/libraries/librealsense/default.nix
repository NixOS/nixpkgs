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
, cudaSupport ? config.cudaSupport, cudaPackages ? { }
, enablePython ? false, pythonPackages ? null
, enableGUI ? false,
}:

assert cudaSupport -> (cudaPackages?cudatoolkit && cudaPackages.cudatoolkit != null);
assert enablePython -> pythonPackages != null;

stdenv.mkDerivation rec {
  pname = "librealsense";
  version = "2.54.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EbnIHnsUgsqN/SVv4m9H7K8gfwni+u82+M55QBstAGI=";
  };

  buildInputs = [
    libusb1
    gcc.cc.lib
  ] ++ lib.optional cudaSupport cudaPackages.cudatoolkit
    ++ lib.optionals enablePython (with pythonPackages; [ python pybind11 ])
    ++ lib.optionals enableGUI [ mesa gtk3 glfw libGLU curl ];

  patches = [
    ./py_pybind11_no_external_download.patch
    ./install-presets.patch
    # https://github.com/IntelRealSense/librealsense/pull/11917
    (fetchpatch {
      name = "fix-gcc13-missing-cstdint.patch";
      url = "https://github.com/IntelRealSense/librealsense/commit/b59b13671658910fc453a4a6bbd61f13ba6e83cc.patch";
      hash = "sha256-zaW8HG8rfsApI5S/3x+x9Fx8xhyTIPNn/fJVFtkmlEA=";
    })
  ];

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
  postInstall = ''
    substituteInPlace $out/lib/cmake/realsense2/realsense2Targets.cmake \
    --replace "\''${_IMPORT_PREFIX}/include" "$dev/include"
  '' + lib.optionalString enablePython  ''
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
