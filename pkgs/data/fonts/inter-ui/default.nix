{ stdenv, fetchzip }:

let
  version = "3.1";
in fetchzip {
  name = "inter-ui-${version}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-UI-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "0cdjpwylynwmab0x5z5lw43k39vis74xj1ciqg8nw12ccprbmj60";

  meta = with stdenv.lib; {
    homepage = https://rsms.me/inter/;
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize ];
  };
}

