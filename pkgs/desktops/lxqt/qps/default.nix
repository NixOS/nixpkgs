{ stdenv, fetchFromGitHub, cmake, qtbase, qtx11extras, qttools,
  lxqt-build-tools }:

stdenv.mkDerivation rec {
  pname = "qps";
  version = "1.10.19";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1vyi1vw4z5j2sp9yhhv91wl2sbg4fh0djqslg1ssc7fww2ka6dx3";
  };

  nativeBuildInputs = [ cmake lxqt-build-tools ];

  buildInputs = [ qtbase qtx11extras qttools ];

  meta = with stdenv.lib; {
    description = "The Qt process manager";
    homepage = https://github.com/lxqt/qps;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
