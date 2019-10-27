{ lib, fetchzip, p7zip }:

let
  version = "0.1";
in fetchzip rec {
  name = "oldsindhi-${version}";

  url = "https://github.com/MihailJP/oldsindhi/releases/download/0.1/OldSindhi-0.1.7z";

  postFetch = ''
    ${p7zip}/bin/7z x $downloadedFile

    install -m444 -Dt $out/share/fonts/truetype OldSindhi/*.ttf
    install -m444 -Dt $out/share/doc/${name}    OldSindhi/README OldSindhi/*.txt
  '';

  sha256 = "0d4l9cg2vmh2pvnqsla8mgcwvc7wjxzcabhlli6633h3ifj2yp7b";

  meta = with lib; {
    homepage = https://github.com/MihailJP/oldsindhi;
    description = "Free Sindhi Khudabadi font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
