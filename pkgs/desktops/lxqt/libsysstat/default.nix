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
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "14q55iayygmjh63zgsb9qa4af766gj9b0jsrmfn85fdiqb8p8yfz";
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
