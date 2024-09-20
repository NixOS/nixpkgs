{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  scdoc,
  util-linux,
  xorg,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ydotool";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "ReimuNotMoe";
    repo = "ydotool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MtanR+cxz6FsbNBngqLE+ITKPZFHmWGsD1mBDk0OVng=";
  };

  postPatch = ''
    substituteInPlace Daemon/ydotoold.c \
      --replace "/usr/bin/xinput" "${xorg.xinput}/bin/xinput"
    substituteInPlace Daemon/ydotool.service.in \
      --replace "/usr/bin/kill" "${util-linux}/bin/kill"
  '';

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    scdoc
  ];

  passthru.tests.basic = nixosTests.ydotool;

  meta = {
    description = "Generic Linux command-line automation tool";
    homepage = "https://github.com/ReimuNotMoe/ydotool";
    license = lib.licenses.agpl3Plus;
    mainProgram = "ydotool";
    maintainers = with lib.maintainers; [
      willibutz
      kraem
    ];
    platforms = lib.platforms.linux;
  };
})
