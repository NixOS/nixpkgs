{ stdenv, fetchFromGitHub, cmake, qtbase, lxqt-build-tools }:

stdenv.mkDerivation rec {
  pname = "libsysstat";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "10h9n7km7yx8bnmzxi4nn1yqq03hizjkrx4745j0mczy7niiffsz";
  };

  nativeBuildInputs = [ cmake lxqt-build-tools ];

  buildInputs = [ qtbase ];

  meta = with stdenv.lib; {
    description = "Library used to query system info and statistics";
    homepage = https://github.com/lxqt/libsysstat;
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
