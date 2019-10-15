{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, qtx11extras, qttools,
  lxqt-build-tools }:

mkDerivation rec {
  pname = "qps";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "03rl59yk3b24j0y0k8dpdpb3yi4f1l642zn5pp5br3s2vwx1vzkg";
  };

  nativeBuildInputs = [ cmake lxqt-build-tools ];

  buildInputs = [ qtbase qtx11extras qttools ];

  meta = with lib; {
    description = "Qt based process manager";
    homepage = https://github.com/lxqt/qps;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
