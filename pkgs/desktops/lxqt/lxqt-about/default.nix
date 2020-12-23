{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtx11extras
, qttools
, qtsvg
, kwindowsystem
, liblxqt
, libqtxdg
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-about";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0m7gan31byy80k9jqfqxx4drvfx0d9savj4shnrabsb3z3fj9h8h";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtx11extras
    qttools
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Dialogue window providing information about LXQt and the system it's running on";
    homepage = "https://github.com/lxqt/lxqt-about";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
