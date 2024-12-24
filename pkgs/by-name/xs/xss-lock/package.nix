{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  docutils,
  pkg-config,
  glib,
  libpthreadstubs,
  libXau,
  libXdmcp,
  xcbutil,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "xss-lock";
  version = "unstable-2018-05-31";

  src = fetchFromGitHub {
    owner = "xdbob";
    repo = "xss-lock";
    rev = "cd0b89df9bac1880ea6ea830251c6b4492d505a5";
    sha256 = "040nqgfh564frvqkrkmak3x3h0yadz6kzk81jkfvd9vd20a9drh7";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    docutils
  ];
  buildInputs = [
    glib
    libpthreadstubs
    libXau
    libXdmcp
    xcbutil
  ];

  passthru.tests = { inherit (nixosTests) xss-lock; };

  meta = with lib; {
    description = "Use external locker (such as i3lock) as X screen saver";
    license = licenses.mit;
    mainProgram = "xss-lock";
    maintainers = with maintainers; [
      malyn
      offline
    ];
    platforms = platforms.linux;
  };
}
