{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "gandom-fonts";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "gandom-font";
    rev = "v${version}";
    hash = "sha256-nez8T0TtRLyXxIIR69LrVGde5ThCvA0fLXkYLyYQRV8=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/gandom-fonts {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/gandom-font";
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی گندم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
