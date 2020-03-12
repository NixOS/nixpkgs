{ stdenv, fetchFromGitHub, cmake, pkgconfig, libdrm
, withPython ? false, python }:

stdenv.mkDerivation {
  pname = "kmsxx";
  version = "2020-02-14";

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "7c5e645112a899ad018219365c3898b0e896353f";
    sha256 = "1hj4gk4gwlvpjprjbrmrbrzqjhdgszsndrb1i4f9z7mjvdv8gij2";
  };

  enableParallelBuilding = true;

  cmakeFlags = stdenv.lib.optional (!withPython) "-DKMSXX_ENABLE_PYTHON=OFF";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libdrm python ];

  meta = with stdenv.lib; {
    description = "C++11 library, utilities and python bindings for Linux kernel mode setting";
    homepage = https://github.com/tomba/kmsxx;
    license = licenses.mpl20;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
