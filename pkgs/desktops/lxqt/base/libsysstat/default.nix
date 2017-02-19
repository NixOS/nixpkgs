{ stdenv, fetchFromGitHub, cmake, qt5, lxqt }:

stdenv.mkDerivation rec {
  name = "libsysstat-${version}";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "libsysstat";
    rev = version;
    sha256 = "1rkbh6jj69wsf8a7w7cq8psqw08vqf9rq5pdnv4xxqb036r4bi31";
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
