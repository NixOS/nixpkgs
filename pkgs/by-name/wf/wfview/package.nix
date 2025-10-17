{
  lib,
  stdenv,
  fetchFromGitLab,
  eigen,
  hidapi,
  libopus,
  libpulseaudio,
  portaudio,
  qt6,
  qt6Packages,
  rtaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wfview";
  version = "2.11";

  src = fetchFromGitLab {
    owner = "eliggett";
    repo = "wfview";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oPgQnldJA3IEZ0FuigdBpArhVcWE0GR8oa/kyYWDvEo=";
  };

  patches = [
    # Remove syscalls during build to make it reproducible
    # We also need to adjust some header paths for darwin
    ./remove-hard-encodings.patch
  ];

  buildInputs = [
    eigen
    hidapi
    libopus
    portaudio
    rtaudio
    qt6.qtbase
    qt6.qtserialport
    qt6.qtmultimedia
    qt6.qtwebsockets
    qt6Packages.qcustomplot
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
  ];

  nativeBuildInputs = with qt6; [
    wrapQtAppsHook
    qmake
  ];

  env.LANG = "C.UTF-8";

  qmakeFlags = [ "wfview.pro" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -pv $out/Applications
    mv -v "$out/bin/wfview.app" $out/Applications

    # wrap executable to $out/bin
    makeWrapper "$out/Applications/wfview.app/Contents/MacOS/wfview" "$out/bin/wfview"
  '';

  meta = {
    description = "Open-source software for the control of modern Icom radios";
    homepage = "https://wfview.org/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "wfview";
    maintainers = with lib.maintainers; [ Cryolitia ];
  };
})
