{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qttools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "qlipper";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "pvanek";
    repo = pname;
    rev = version;
    sha256 = "0zpkcqfylcfwvadp1bidcrr64d8ls5c7bdnkfqwjjd32sd35ly60";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qtbase
    qttools
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Cross-platform clipboard history applet";
    homepage = "https://github.com/pvanek/qlipper";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
