{ stdenv
, lib
, fetchFromGitHub
, cmake
, libusb1
, ninja
, pkgconfig
, writeTextFile
, withPython ? false
, pythonPackages ? null }:

stdenv.mkDerivation rec {
  pname = "librealsense";
  version = "2.36.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dfkhnybnd8qnljf3y3hjyamaqzw733hb3swy4hjcsdm9dh0wpay";
  };

  buildInputs = [
    libusb1
  ];

  patches = lib.optionals withPython [
    ./py_sitepackages_dir.patch
  ];

  propagatedBuildInputs = lib.optionals withPython [
    pythonPackages.python
    pythonPackages.setuptools
    pythonPackages.wheel
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkgconfig
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=ON"
    "-DBUILD_GRAPHICAL_EXAMPLES=OFF"
    "-DBUILD_GLSL_EXTENSIONS=OFF"
  ] ++ lib.optionals withPython [
      "-DBUILD_PYTHON_BINDINGS:bool=true"
      "-DXXNIX_PYTHON_SITEPACKAGES=${placeholder "out"}/${pythonPackages.python.sitePackages}"
    ];

  # ensure python package contains its __init__.py. for some reason the install
  # script does not do this, and it's questionable if intel knows it should be
  # done
  # ( https://github.com/IntelRealSense/meta-intel-realsense/issues/20 )
  postInstall = if withPython then ''
    cp ../wrappers/python/pyrealsense2/__init__.py $out/${pythonPackages.python.sitePackages}/pyrealsense2
  '' else null;

  meta = with stdenv.lib; {
    description = "A cross-platform library for Intel® RealSense™ depth cameras (D400 series and the SR300)";
    homepage = "https://github.com/IntelRealSense/librealsense";
    license = licenses.asl20;
    maintainers = with maintainers; [ brian-dawn ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
