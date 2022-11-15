{ lib, fetchzip }:

fetchzip rec {
  pname = "alkalami";
  version = "2.000";

  url = "https://software.sil.org/downloads/r/alkalami/Alkalami-${version}.zip";

  postFetch = ''
    rm -rf $out/web $out/manifest.json
    mkdir -p $out/share/{doc/${pname},fonts/truetype}
    mv $out/*.ttf $out/share/fonts/truetype/
    mv $out/*.txt $out/documentation $out/share/doc/${pname}/
  '';

  sha256 = "sha256-GjX3YOItLKSMlRjUbBgGp2D7QS/pOJQYuQJzW+iqBNo=";

  meta = with lib; {
    homepage = "https://software.sil.org/alkalami/";
    description = "A font for Arabic-based writing systems in the Kano region of Nigeria and in Niger";
    license = licenses.ofl;
    maintainers = [ maintainers.vbgl ];
    platforms = platforms.all;
  };
}
