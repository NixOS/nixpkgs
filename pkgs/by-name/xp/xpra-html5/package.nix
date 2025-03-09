{
  lib,
  fetchFromGitHub,
  stdenv,
  python3,
  uglify-js,
}:
stdenv.mkDerivation rec {
  name = "xpra-html5";
  version = "17";

  src = fetchFromGitHub {
    owner = "Xpra-org";
    repo = "xpra-html5";
    tag = "v${version}";
    hash = "sha256-SwP7NazsiUyDD4LUziCwN0X9GTQVq0lYM2jXqNaXLEA=";
  };
  buildInputs = [
    python3
    uglify-js
  ];
  installPhase = "python $src/setup.py install $out /share/xpra/www /share/xpra/www";

  meta = {
    homepage = "https://xpra.org/";
    downloadPage = "https://github.com/Xpra-org/xpra-html5";
    description = "HTML5 client for Xpra";
    changelog = "https://github.com/Xpra-org/xpra-html5/releases/tag/v${version}";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      catern
    ];
  };
}
