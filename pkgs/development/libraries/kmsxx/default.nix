{ stdenv, fetchFromGitHub, cmake, pkgconfig, libdrm, python }:

stdenv.mkDerivation rec {
  pname = "kmsxx";
  version = "2018-10-23";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "c0093c91f0fa2fd6a5b9d1b206a6f44dcd55bfb5";
    sha256 = "03rv92r938nxb4k4gwcvxy76jnhxdx6x60b58jws83285hd9rgkf";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libdrm python ];

  pythonPath = [ ];
  passthru.python = python;

  meta = with stdenv.lib; {
    description = "C++11 library, utilities and python bindings for Linux kernel mode setting";
    homepage = https://github.com/tomba/kmsxx;
    license = licenses.mpl20;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
