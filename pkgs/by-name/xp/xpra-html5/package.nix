{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  python3,
  uglify-js,
  gitUpdater,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "xpra-html5";
  version = "17";

  src = fetchFromGitHub {
    owner = "Xpra-org";
    repo = "xpra-html5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SwP7NazsiUyDD4LUziCwN0X9GTQVq0lYM2jXqNaXLEA=";
  };

  buildInputs = [
    python3
    uglify-js
  ];

  installPhase = ''
    runHook preInstall
    python $src/setup.py install $out /share/xpra/www /share/xpra/www
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://xpra.org/";
    downloadPage = "https://xpra.org/src/";
    description = "HTML5 client for Xpra";
    changelog = "https://github.com/Xpra-org/xpra-html5/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      catern
      lucasew
    ];
  };
})
