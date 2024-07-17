{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sahel-fonts";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "sahel-font";
    rev = "v${version}";
    hash = "sha256-U4tIICXZFK9pk7zdzRwBPIPYFUlYXPSebnItUJUgGJY=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/sahel-fonts {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/sahel-font";
    description = "A Persian (farsi) Font - فونت (قلم) فارسی ساحل";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
