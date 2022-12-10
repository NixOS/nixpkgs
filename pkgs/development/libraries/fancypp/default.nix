{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "fancypp";
  version = "unstable-2021-04-08";

  src = fetchFromGitHub {
    owner = "Curve";
    repo = "fancypp";
    rev = "ede7f712a08f7c66ff4a5590ad94a477c48850a5";
    sha256 = "sha256-E2JsQnvrqrZFYo+xBJr7xDCoPnRQftqUjjBpZzFvIic=";
  };

  # Header-only library.
  dontBuild = true;

  installPhase = ''
    mkdir "$out"
    cp -r include "$out"
  '';

  meta = with lib; {
    description = "Tiny C++ Library for terminal colors and more!";
    homepage = "https://github.com/Curve/fancypp";
    maintainers = with maintainers; [ aidalgol ];
    license = licenses.mit;
  };
}
