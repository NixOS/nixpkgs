{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  eigen,
  hidapi,
  libopus,
  libpulseaudio,
  portaudio,
  rtaudio,
}:

stdenv.mkDerivation (finalAttr: {
  pname = "wfview";
  version = "2.10";

  src = fetchFromGitLab {
    owner = "eliggett";
    repo = "wfview";
    rev = "v${finalAttr.version}";
    hash = "sha256-bFTblsDtFAakbSJfSfKgvoxd1DTSv++rxU6R3/uWo+4=";
  };

  patches = [
    # Remove syscalls during build to make it reproducible
    # We also need to adjust some header paths for darwin
    ./remove-hard-encodings.patch
  ];

  buildInputs = (
    [
      eigen
      hidapi
      libopus
      libpulseaudio
      portaudio
      rtaudio
    ]
    ++ (with kdePackages; [
      qtbase
      qcustomplot
      qtmultimedia
      qtserialport
      qtwebsockets
    ])
  );

  nativeBuildInputs = with kdePackages; [
    wrapQtAppsHook
    qmake
  ];

  env.LANG = "C.UTF-8";

  qmakeFlags = [ "wfview.pro" ];

  meta = {
    description = "Open-source software for the control of modern Icom radios";
    homepage = "https://wfview.org/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Cryolitia ];
  };
})
