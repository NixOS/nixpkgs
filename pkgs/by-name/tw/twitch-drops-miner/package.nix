{
  lib,
  fetchFromGitHub,
  python3Packages,

  libayatana-appindicator,
  tcl,
  tk,
  gtk3,

  unstableGitUpdater,
}:
python3Packages.buildPythonApplication {
  pname = "twitchdropsminer";
  version = "0-unstable-2025-3-24";
  format = "other";

  src = fetchFromGitHub {
    owner = "DevilXD";
    repo = "TwitchDropsMiner";
    rev = "714558965fce217005ef5ad2c11da90a6834e0b1";
    hash = "sha256-2SrPXddWbNjh7F+mkrqFu9q1JVSJLVE6uajGFQbErU8=";
  };

  patches = [
    ./0001-data-paths.patch
    ./0002-path-constants.patch
    ./0003-create-runtime-directory.patch
  ];

  postPatch = ''
    substituteInPlace build.spec \
      --subst-var-by "gtk3" "${gtk3}" \
      --subst-var-by "tcl" "${tcl}" \
      --subst-var-by "tk" "${tk}" \
      --replace-fail "/usr/lib/{arch}-linux-gnu" "${libayatana-appindicator}/lib"

    substituteInPlace constants.py \
      --subst-var "out"
  '';

  dependencies = with python3Packages; [
    tkinter
    aiohttp
    pillow
    pystray
    pygobject3
    truststore
  ];

  buildInputs = [
    libayatana-appindicator
    gtk3
  ];

  nativeBuildInputs = [
    python3Packages.pyinstaller
  ];

  buildPhase = ''
    runHook preBuild

    pyinstaller --clean --noconfirm build.spec

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share
    mv dist/Twitch\ Drops\ Miner\ \(by\ DevilXD\) $out/bin/twitch-drops-miner
    mv icons $out/share/icons
    mv lang $out/share/lang

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "GUI App to automine twitch drops";
    homepage = "https://github.com/DevilXD/TwitchDropsMiner";
    mainProgram = "twitch-drops-miner";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyukuru ];
  };
}
