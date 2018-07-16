{ stdenv, fetchFromGitHub, cmake, qt5, lxqt }:

stdenv.mkDerivation rec {
  name = "libsysstat-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "libsysstat";
    rev = version;
    sha256 = "0ad5pcr5lq1hvrfijvddvz2fvsmh1phb54wb0f756av0kyiwq0gb";
  };

  nativeBuildInputs = [ cmake lxqt.lxqt-build-tools ];

  buildInputs = [ qt5.qtbase ];

  meta = with stdenv.lib; {
    description = "Library used to query system info and statistics";
    homepage = https://github.com/lxde/libsysstat;
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
