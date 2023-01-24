{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "hannom";
  version = "2005";

  src = fetchzip {
    url = "mirror://sourceforge/vietunicode/hannom/hannom%20v${version}/hannomH.zip";
    stripRoot = false;
    hash = "sha256-Oh8V72tYvVA6Sk0f9UTIkRQYjdUbEB/fmCSaRYfyoP8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "UNICODE Han Nom Font Set";
    longDescription = ''
      The true type fonts HAN NOM A and HAN NOM B have been developed by Chan
      Nguyen Do Quoc Bao (Germany), To Minh Tam (USA) and Ni sinh Thien Vien Vien
      Chieu (Vietnam). Their work got started in 2001, completed in 2003, and
      publicized in 2005. These two true type fonts can be used with WIN-2000 or
      WIN-XP and Office XP or Office 2003 to display Han and Nom characters with
      code points by the Unicode Standard. Two sets of true type fonts are
      available with high and low resolutions.
    '';
    homepage = "https://vietunicode.sourceforge.net/fonts/fonts_hannom.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.all;
  };
}
