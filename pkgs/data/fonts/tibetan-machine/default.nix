{ fetchzip, lib }:

let
  version = "1.901b";
in
fetchzip {
  name = "tibetan-machine-${version}";
  url = "mirror://debian/pool/main/f/fonts-tibetan-machine/fonts-tibetan-machine_${version}.orig.tar.bz2";
  sha256 = "sha256-A+RgpFLsP4iTzl0PMRHaNzWGbDR5Qa38lRegNJ96ULo=";

  postFetch = ''
    mkdir -p $out/share/fonts
    tar xf $downloadedFile --strip-components=1 -C $out/share/fonts ttf-tmuni-${version}/TibMachUni-${version}.ttf
  '';

  meta = with lib; {
    description = "Tibetan Machine - an OpenType Tibetan, Dzongkha and Ladakhi font";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
