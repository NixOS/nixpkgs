{ fetchzip, lib }:

let
  version = "0.0.20060226";
in
fetchzip {
  name = "lao-${version}";
  url = "mirror://debian/pool/main/f/fonts-lao/fonts-lao_${version}.orig.tar.xz";
  sha256 = "sha256-Ti3DNOgLR5VBJ1mSe8M+qs4UYbCR7qOPgqxRfmHa+jY=";

  postFetch = ''
    mkdir -p $out/share/fonts
    tar xf $downloadedFile --strip-components=1 -C $out/share/fonts fonts-lao-${version}/Phetsarath_OT.ttf
  '';

  meta = with lib; {
    description = "TrueType font for Lao language";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
