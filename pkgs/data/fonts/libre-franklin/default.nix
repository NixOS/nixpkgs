{ lib, fetchFromGitHub }:

fetchFromGitHub rec {
  name = "libre-franklin-1.014";

  owner = "impallari";
  repo = "Libre-Franklin";
  rev = "006293f34c47bd752fdcf91807510bc3f91a0bd3";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype */OTF/*.otf
    install -m444 -Dt $out/share/doc/${name}    README.md FONTLOG.txt
  '';

  sha256 = "0aq280m01pbirkzga432340aknf2m5ggalw0yddf40sqz7falykf";

  meta = with lib; {
    description = "A reinterpretation and expansion based on the 1912 Morris Fuller Benton’s classic.";
    homepage = https://github.com/impallari/Libre-Franklin;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
