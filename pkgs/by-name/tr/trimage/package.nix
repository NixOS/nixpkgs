{
  lib,
  stdenv,
  fetchFromGitHub,

  python3,
  installShellFiles,
  makeWrapper,
  qt5,

  advancecomp,
  jpegoptim,
  optipng,
  pngcrush,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ pyqt5 ]);

  binPath = lib.makeBinPath [
    advancecomp
    jpegoptim
    optipng
    pngcrush
  ];
in
stdenv.mkDerivation {
  pname = "trimage";
  version = "1.0.7-dev";

  src = fetchFromGitHub {
    owner = "Kilian";
    repo = "Trimage";
    rev = "ad74684272a31eee6af289cc59fd90fd962d2806";
    hash = "sha256-jdcGGTqr3f3Xnp6thYmASQYiZh9nagLUTmlFnJ5Hqmc=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    qt5.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R trimage $out

    installManPage doc/trimage.1
    install -Dm444 desktop/trimage.desktop -t $out/share/applications
    install -Dm444 desktop/trimage.svg -t $out/share/icons/hicolor/scalable/apps

    makeWrapper ${pythonEnv}/bin/python $out/bin/trimage \
          --add-flags "$out/trimage/trimage.py" \
          --prefix PATH : ${binPath} \
          "''${qtWrapperArgs[@]}"

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform tool for optimizing PNG and JPG files";
    homepage = "https://github.com/Kilian/Trimage";
    license = lib.licenses.mit;
    mainProgram = "trimage";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
