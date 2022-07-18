{ fetchzip, lib }:

let
  version = "0.6";
in
fetchzip {
  name = "lklug-sinhala-${version}";
  url = "mirror://debian/pool/main/f/fonts-lklug-sinhala/fonts-lklug-sinhala_${version}.orig.tar.xz";
  sha256 = "sha256-Fy+QnAajA4yLf/I1vOQll5pRd0ZLfLe8UXq4XMC9qNc=";

  postFetch = ''
    mkdir -p $out/share/fonts
    tar xf $downloadedFile --strip-components=1 -C $out/share/fonts fonts-lklug-sinhala-${version}/lklug.ttf
  '';

  meta = with lib; {
    description = "Unicode Sinhala font by Lanka Linux User Group";
    homepage = "http://www.lug.lk/fonts/lklug";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
