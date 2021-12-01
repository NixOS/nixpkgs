{ lib, fetchzip }:

let
  version = "1.0";
in fetchzip rec {
  name = "oldsindhi-${version}";

  url = "https://github.com/MihailJP/oldsindhi/releases/download/v${version}/OldSindhi-${version}.tar.xz";

  postFetch = ''
    tar -xJf $downloadedFile --strip-components=1
    install -m444 -Dt $out/share/fonts/truetype *.ttf
    install -m444 -Dt $out/share/doc/${name} README *.txt
  '';

  sha256 = "03c483vbrwz2fpdfbys42fmik9788zxfmjmc4fgq4s2d0mraa0j1";

  meta = with lib; {
    homepage = "https://github.com/MihailJP/oldsindhi";
    description = "Free Sindhi Khudabadi font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = with licenses; [mit ofl];
    platforms = platforms.all;
  };
}
