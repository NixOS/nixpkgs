{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools, qtx11extras, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg }:

mkDerivation rec {
  pname = "lxqt-about";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0dj2rhbhnkzmv1iqqyq0bcp03imwnvxdr7rnpqnrs9kkjacm8zvr";
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

  meta = with lib; {
    description = "Dialogue window providing information about LXQt and the system it's running on";
    homepage = https://github.com/lxqt/lxqt-about;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
