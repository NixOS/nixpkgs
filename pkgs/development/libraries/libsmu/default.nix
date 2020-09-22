{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkgconfig
, libusb
, boost
, doxygen
, pythonSupport ? false
, python
}:

stdenv.mkDerivation rec {
  pname = "libsmu";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m3bfrs1ipv2mvfhvfsmaw30xl5f7pdw70pd5ahj3lgiyfss74z3";
  };

  patchPhase = ''
    substituteInPlace CMakeLists.txt --replace "/etc/udev/rules.d" "${placeholder "out"}/etc/udev/rules.d"
  '';

  nativeBuildInputs = with python.pkgs; [
    cmake
    pkgconfig
    doxygen
  ]
  ++ lib.optionals (pythonSupport) [
    python
    cython
    python.pkgs.setuptools
  ]
  ;

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
