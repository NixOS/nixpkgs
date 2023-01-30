{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "samim-fonts";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "samim-font";
    rev = "v${version}";
    hash = "sha256-erT8iV5YHbEN47nEE5p5CbQYUgm8daOjymLAWF4fpVk=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/samim-fonts {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/samim-font";
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی صمیم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
