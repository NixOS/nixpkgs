{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, lxqt-build-tools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "libsysstat";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1pbshhg8pjkzkka5f2rxfxal7rb4fjccpgj07kxvgcnqlah27ydk";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Library used to query system info and statistics";
    homepage = "https://github.com/lxqt/libsysstat";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
