{ lib, fetchzip }:

let
  version = "2005";
in fetchzip {
  name = "hannom-${version}";

  url = "mirror://sourceforge/vietunicode/hannom/hannom%20v${version}/hannomH.zip";

  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mv $out/*.ttf -t $out/share/fonts/truetype
    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  sha256 = "sha256-zOYJxEHl4KM0ncVQDBs9+e3z8DxzF2ef3pRj0OVSuUo=";

  meta = with lib; {
    description = "UNICODE Han Nom Font Set";
    homepage = "http://vietunicode.sourceforge.net/fonts/fonts_hannom.html";
    longDescription = ''
      The true type fonts HAN NOM A and HAN NOM B have been developed by Chan
      Nguyen Do Quoc Bao (Germany), To Minh Tam (USA) and Ni sinh Thien Vien Vien
      Chieu (Vietnam). Their work got started in 2001, completed in 2003, and
      publicized in 2005. These two true type fonts can be used with WIN-2000 or
      WIN-XP and Office XP or Office 2003 to display Han and Nom characters with
      code points by the Unicode Standard. Two sets of true type fonts are
      available with high and low resolutions.
    '';
    license = licenses.unfree;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.all;
  };
}
