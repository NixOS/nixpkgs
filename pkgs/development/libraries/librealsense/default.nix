{ stdenv
, config
, lib
, fetchFromGitHub
, cmake
, libusb1
, nlohmann_json
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
  version = "2.56.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1ICSJqr5WRePLIHsD3T2L0Nxdn1LWaHqHDJrfTIRl88=";
  };

  buildInputs = [
    libusb1
    gcc.cc.lib
    nlohmann_json
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
    ++ lib.optionals enablePython (with pythonPackages; [ python pybind11 ])
    ++ lib.optionals enableGUI [ mesa gtk3 glfw libGLU curl ];

  patches = [
    ./py_pybind11_no_external_download.patch
    ./install-presets.patch
  ];

  postPatch = ''
    # use nixpkgs nlohmann_json instead of fetching it
    substituteInPlace third-party/CMakeLists.txt \
      --replace-fail \
        'include(CMake/external_json.cmake)' \
        'find_package(nlohmann_json 3.11.3 REQUIRED)'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
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
    --replace-fail "\''${_IMPORT_PREFIX}/include" "$dev/include"
  '' + lib.optionalString enablePython  ''
    cp ../wrappers/python/pyrealsense2/__init__.py $out/${pythonPackages.python.sitePackages}/pyrealsense2
  '';

  meta = with lib; {
    description = "Cross-platform library for Intel® RealSense™ depth cameras (D400 series and the SR300)";
    homepage = "https://github.com/IntelRealSense/librealsense";
    license = licenses.asl20;
    maintainers = with maintainers; [ brian-dawn pbsds ];
    platforms = platforms.unix;
  };
}
