{ lib, fetchzip }:

let version = "1.100"; in
fetchzip rec {
  name = "ankacoder-${version}";
  url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/anka-coder-fonts/AnkaCoder.${version}.zip";

  postFetch = ''
    unzip $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  sha256 = "1jqx9micfmiarqh9xp330gl96v3vxbwzz9cmg2vi845n9md4im85";

  meta = with lib; {
    description = "Anka/Coder fonts";
    homepage = https://code.google.com/archive/p/anka-coder-fonts;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
