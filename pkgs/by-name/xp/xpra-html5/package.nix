{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  python3,
  uglify-js,
}:
let
  version = "17";
in
stdenvNoCC.mkDerivation {
  name = "xpra-html5";
  inherit version;

  src = fetchFromGitHub {
    owner = "Xpra-org";
    repo = "xpra-html5";
    rev = "v${version}";
    hash = "sha256-SwP7NazsiUyDD4LUziCwN0X9GTQVq0lYM2jXqNaXLEA=";
  };
  buildInputs = [
    python3
    uglify-js
  ];
  installPhase = "python $src/setup.py install $out /share/xpra/www /share/xpra/www";

  meta = with lib; {
    homepage = "https://xpra.org/";
    downloadPage = "https://xpra.org/src/";
    description = "HTML5 client for Xpra";
    changelog = "https://github.com/Xpra-org/xpra-html5/releases/tag/v${version}";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [
      catern
    ];
  };
}
