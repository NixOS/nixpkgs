{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "unfonts-core";
  version = "1.0.2-080608";

  src = fetchurl {
    url = "https://kldp.net/unfonts/release/2607-un-fonts-core-${version}.tar.gz";
    hash = "sha256-OwpydPmqt+jw8ZOMAacOFYF2bVG0lLoUVoPzesVXkY4=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype *.ttf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://kldp.net/unfonts/";
    description = "Korean Hangul typeface collection";
    longDescription = ''
      The Un-fonts come from the HLaTeX as type1 fonts in 1998 by Koaunghi Un, he made type1 fonts to use with Korean TeX (HLaTeX) in the late 1990's and released it under the GPL license.

      They were converted to TrueType with the FontForge (PfaEdit) by Won-kyu Park in 2003.
    '';
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.ehmry ];
  };
}
