{ lib, fetchurl }:

fetchurl {
  pname = "linja-sike";
  version = "5.0";

  url = "https://wyub.github.io/tokipona/linja-sike-5.otf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/opentype/linja-sike.otf
  '';

  sha256 = "sha256-TJcKIK6byBb9/zyoKHTmhMpOGwHYG/ZPmm72huSO/Yo=";

  meta = with lib; {
    description = "An extensive sitelen pona font by lipamanka";
    homepage = "https://docs.google.com/document/d/1d8kUIAVlB-JNgK3LWr_zVCuUOZTh2hF7CfC6xQgxsBs/edit?usp=sharing";
    downloadPage = "https://wyub.github.io/tokipona/linjasike";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ somasis ];
  };
}
