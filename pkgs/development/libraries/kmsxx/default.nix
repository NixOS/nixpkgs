{ stdenv, fetchFromGitHub, cmake, pkgconfig, libdrm
, withPython ? false, python }:

stdenv.mkDerivation {
  pname = "kmsxx";
  version = "2020-08-04";

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "38bee3092f2d477f1baebfcae464f888d3d04bbe";
    sha256 = "0xz4m9bk0naawxwpx5cy1j3cm6c8c9m5y551csk88y88x1g0z0xh";
  };

  enableParallelBuilding = true;

  cmakeFlags = stdenv.lib.optional (!withPython) "-DKMSXX_ENABLE_PYTHON=OFF";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libdrm python ];

  meta = with stdenv.lib; {
    description = "C++11 library, utilities and python bindings for Linux kernel mode setting";
    homepage = "https://github.com/tomba/kmsxx";
    license = licenses.mpl20;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
