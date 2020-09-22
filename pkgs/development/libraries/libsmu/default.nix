{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libusb
, boost
, doxygen
, pythonSupport ? false # currently tries to install pip packages in $HOME
, python
}:

stdenv.mkDerivation rec {
  pname = "libsmu";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Ko3szo7Oa0k7W/sAj3M7FAifIJR7mG40oy6QF2gzMmQ=";
  };

  patches = [ ./libsmu-pc.patch ];

  cmakeFlags = [
    "-DBUILD_CLI=ON"
    "-DWITH_DOC=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DINSTALL_UDEV_RULES=ON"
    "-DUDEV_RULES_PATH=${placeholder "out"}/etc/udev/rules.d"
    "-DBUILD_TESTS=OFF" # tests require access to the ADALM1000 hardware
    "-DBUILD_PYTHON=${if pythonSupport then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
  ]
  ++ lib.optionals (pythonSupport) [
    (python.withPackages ( ps: with ps; [
      build
      wheel
      setuptools
      cython
      six
    ]))
  ];

  buildInputs = [
    libusb
    boost
  ];

  meta = with lib; {
    description = "Software abstractions for the ADALM1000 USB SMU";
    homepage = "https://analogdevicesinc.github.io/libsmu/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.evils ];
  };
}
