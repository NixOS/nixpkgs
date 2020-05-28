{ lib, fetchzip }:

let
  version = "3.13";
in fetchzip {
  name = "inter-${version}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "08ykl27qzv59c5jb72zr5hpyssdz2v85ih9n85yd878f3khpqyzd";

  meta = with lib; {
    homepage = "https://rsms.me/inter/";
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize dtzWill ];
  };
}

