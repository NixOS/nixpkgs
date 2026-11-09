{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch2,
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
  version = "2.23";

  src = fetchFromGitLab {
    owner = "eliggett";
    repo = "wfview";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RQjNdeBvONxqUdybUvO17lTFjM4kkGx10fNdHsvH+0M=";
  };

  patches = [
    # Remove syscalls during build to make it reproducible
    # We also need to adjust some header paths for darwin
    ./remove-hard-encodings.patch

    # Fix build with Qt 6.11.1, https://gitlab.com/eliggett/wfview/-/merge_requests/51
    (fetchpatch2 {
      url = "https://gitlab.com/Cryolitia/wfview/-/commit/b26c898c219df8935dcb85969465ed995f64d875.patch";
      hash = "sha256-KXWz6gdaPewq+RLhhkZT3CYz6yqbVXMubAUfabhgqX0=";
    })
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
