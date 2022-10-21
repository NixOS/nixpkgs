{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkgconfig
, libusb
, boost
, doxygen
, gtest
, pythonSupport ? false # currently tries to install pip packages in $HOME
, python
}:

stdenv.mkDerivation rec {
  pname = "libsmu";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = pname;
    rev = "dbb484f004d9eb5251aa4667f5cf09b3ff5610e2"; # v1.0.4 but not ambiguous with the branch by that name
    hash = "sha256-Ko3szo7Oa0k7W/sAj3M7FAifIJR7mG40oy6QF2gzMmQ=";
  };

  patches = [ ./libsmu-pc.patch ];

  cmakeFlags = [
    "-DBUILD_CLI=ON"
    "-DWITH_DOC=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DINSTALL_UDEV_RULES=ON"
    "-DUDEV_RULES_PATH=${placeholder "out"}/etc/udev/rules.d"
    "-DBUILD_TESTS=ON"
  ]
  ++ (if (pythonSupport) then [
    "-DBUILD_PYTHON=ON"
  ]
  else [
    "-DBUILD_PYTHON=OFF"
  ]);

  nativeBuildInputs = with python.pkgs; [
    cmake
    pkgconfig
    doxygen
    gtest
  ]
  ++ lib.optionals (pythonSupport) [
    python
    cython
    python.pkgs.setuptools
    build
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
