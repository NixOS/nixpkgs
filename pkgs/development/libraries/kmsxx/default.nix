{ stdenv, fetchFromGitHub, cmake, pkgconfig, libdrm, python }:

stdenv.mkDerivation rec {
  pname = "kmsxx";
  version = "2017-10-10";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "f32b82c17cd357ae1c8ed2636266113955293feb";
    sha256 = "14panqdqq83wh6wym5afdiyrr78mb12ga63pgrppj27kgv398yjj";
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
