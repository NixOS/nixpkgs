{ stdenv, fetchzip }:

let
  version = "3.0";
in fetchzip {
  name = "inter-ui-${version}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-UI-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "16qmb8farkh41i56f0vvbxcg32rbg7my64amwz5y8gyy73i3320q";

  meta = with stdenv.lib; {
    homepage = https://rsms.me/inter/;
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize ];
  };
}

