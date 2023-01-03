{ lib, fetchzip }:

let
  rev = "69132c99873894746c9710707aaeb2cea2609709";
in
fetchzip {
  pname = "sitelen-seli-kiwen";
  version = "unstable-2022-06-28";

  url = "https://raw.githubusercontent.com/kreativekorp/sitelen-seli-kiwen/${rev}/sitelenselikiwen.zip";
  hash = "sha256-63sl/Ha2QAe8pVKCpLNs//DB0kjLdW01u6tVMrGquIU=";
  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype}
    mv $out/*.eot $out/share/fonts/opentype/
    mv $out/*.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "A handwritten sitelen pona font supporting UCSUR";
    homepage = "https://www.kreativekorp.com/software/fonts/sitelenselikiwen/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ somasis ];
  };
}
