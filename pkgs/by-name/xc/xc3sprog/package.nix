{
  lib,
  stdenv,
  fetchsvn,
  cmake,
  pkg-config,
  libusb-compat-0_1,
  libftdi1,
}:

# The xc3sprog project doesn't seem to make proper releases, they only put out
# prebuilt binary subversion snapshots on sourceforge.

stdenv.mkDerivation rec {
  version = "795";
  pname = "xc3sprog";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/xc3sprog/code/trunk";
    sha256 = "sha256-E0MGwC3gIfl60gjGaSeSPTR5jJm9r8m7Et3402lek/w=";
    rev = version;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libusb-compat-0_1
    libftdi1
  ];

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    # fix build with gcc 11+
    "-DCMAKE_CXX_STANDARD=14"
  ];

  meta = with lib; {
    description = "Command-line tools for programming FPGAs, microcontrollers and PROMs via JTAG";
    homepage = "https://xc3sprog.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
