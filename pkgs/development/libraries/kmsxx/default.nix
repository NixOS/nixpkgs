{ stdenv, fetchFromGitHub, cmake, pkgconfig, libdrm
, withPython ? false, python }:

stdenv.mkDerivation {
  pname = "kmsxx";
  version = "2019-10-28";

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "d29da28c7f2a0212d834136fe64fb8ca96a0a235";
    sha256 = "0r94qjyy3s36s32s1xkzij0g2pfwigmyrshw8ni2xli7mg87g1zm";
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
