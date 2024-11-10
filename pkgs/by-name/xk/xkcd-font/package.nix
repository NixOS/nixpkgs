{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "xkcd-font";
  version = "unstable-2017-08-24";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = pname;
    rev = "5632fde618845dba5c22f14adc7b52bf6c52d46d";
    hash = "sha256-1DgSx2L+OpXuPVSXbbl/hcZUyBK9ikPyGWuk6wNzlwc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/opentype/ xkcd/build/xkcd.otf
    install -Dm444 -t $out/share/fonts/truetype/ xkcd-script/font/xkcd-script.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Xkcd font";
    homepage = "https://github.com/ipython/xkcd-font";
    license = licenses.cc-by-nc-30;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
