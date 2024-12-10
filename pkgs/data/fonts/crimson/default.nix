{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "crimson";
  version = "2014.10";

  src = fetchFromGitHub {
    owner = "skosch";
    repo = "Crimson";
    rev = "fonts-october2014";
    hash = "sha256-Wp9L77q93TRmrAr0P4iH9gm0tqFY0X/xSsuFcd19aAE=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype "Desktop Fonts/OTF/"*.otf
    install -m444 -Dt $out/share/doc/${pname}-${version}    README.md

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/skosch/Crimson";
    description = "A font family inspired by beautiful oldstyle typefaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
