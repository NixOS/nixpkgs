{ fetchzip, lib }:

let
  version = "2.01";
in
fetchzip {
  name = "kacst-${version}";
  url = "mirror://debian/pool/main/f/fonts-kacst/fonts-kacst_${version}+mry.orig.tar.bz2";
  sha256 = "sha256-pIO58CXfmKYRKYJ1oI+tjTwlKBRnkZ/CpIM2Xa0CDA4=";

  postFetch = ''
    mkdir -p $out/share/fonts
    tar xjf $downloadedFile --strip-components=1 -C $out/share/fonts
  '';

  meta = with lib; {
    description = "KACST Latin-Arabic TrueType fonts";
    license = licenses.gpl2Only;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
