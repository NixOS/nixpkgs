{ stdenv, fetchFromGitHub, cmake, pkgconfig, libdrm, python }:

stdenv.mkDerivation rec {
  pname = "kmsxx";
  version = "2018-09-10";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "524176c33ee2b79f78d454fa621e0d32e7e72488";
    sha256 = "0wyg0zv207h5a78cwmbg6fi8gr8blbbkwngjq8hayfbg45ww0jy8";
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
