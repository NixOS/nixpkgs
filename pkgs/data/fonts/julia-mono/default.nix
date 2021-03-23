{ lib, fetchzip }:

let
  version = "0.034";

in fetchzip {
  name = "JuliaMono-${version}";
  url = "https://github.com/cormullion/juliamono/releases/download/v${version}/JuliaMono.zip";
  sha256 = "sha256:0xx3mhzs17baaich67kvwyzqg8h9ga11jrja2i8sxx4861dp1z85";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "A monospaced font for scientific and technical computing";
    longDescription = ''
      JuliaMono is a monospaced typeface designed for use in text editing environments that require a wide range of specialist and technical Unicode characters. It was intended as a fun experiment to be presented at the 2020 JuliaCon conference in Lisbon, Portugal (which of course didn’t physically happen in Lisbon, but online).
    '';
    maintainers = with maintainers; [ suhr ];
    platforms = with platforms; all;
    homepage = "https://cormullion.github.io/pages/2020-07-26-JuliaMono/";
    license = licenses.ofl;
  };
}
