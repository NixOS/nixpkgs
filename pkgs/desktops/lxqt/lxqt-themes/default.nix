{ lib
, stdenv
, fetchFromGitHub
, cmake
, lxqt-build-tools
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "lxqt-themes";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-bAdwC1YrXCT4eJUafTK6kcfQ/YnMbBLHyyWvsBLIisA=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
