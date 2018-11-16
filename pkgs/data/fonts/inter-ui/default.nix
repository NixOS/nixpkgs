{ stdenv, fetchzip }:

let
  version = "2.5";
in fetchzip {
  name = "inter-ui-${version}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-UI-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "1d88y6c9vbjz5siazhavnpfpazfkvpbcbb4pdycbnj03mmx6y07v";

  meta = with stdenv.lib; {
    homepage = https://rsms.me/inter/;
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize ];
  };
}

