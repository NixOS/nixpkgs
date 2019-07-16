{ lib, fetchzip }:

let version = "1.100"; in
fetchzip rec {
  name = "ankacoder-condensed-${version}";
  url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/anka-coder-fonts/AnkaCoderCondensed.${version}.zip";

  postFetch = ''
    unzip $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  sha256 = "0i80zpr2y9368rg2i6x8jv0g7d03kdyr5h7w9yz7pjd7i9xd8439";

  meta = with lib; {
    description = "Anka/Coder Condensed font";
    homepage = https://code.google.com/archive/p/anka-coder-fonts;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

