{ lib, fetchzip }:

let
  version = "0.016";
in fetchzip rec {
  name = "eb-garamond-${version}";

  url = "https://bitbucket.org/georgd/eb-garamond/downloads/EBGaramond-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.otf                                          -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*Changes \*README.markdown \*README.xelualatex -d "$out/share/doc/${name}"
  '';

  sha256 = "04jq4mpln85zzbla8ybsjw7vn9qr3r0snmk5zykrm24imq7ripv3";

  meta = with lib; {
    homepage = http://www.georgduffner.at/ebgaramond/;
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    maintainers = with maintainers; [ relrod rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
