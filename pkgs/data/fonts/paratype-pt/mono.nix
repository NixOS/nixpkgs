{ stdenv, fetchzip }:

fetchzip rec {
  name = "paratype-pt-mono";

  url = [
    https://company.paratype.com/system/attachments/631/original/ptmono.zip
    http://rus.paratype.ru/system/attachments/631/original/ptmono.zip
  ];

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.txt -d $out/share/doc/paratype
  '';

  sha256 = "07kl82ngby55khvzsvn831ddpc0q8djgz2y6gsjixkyjfdk2xjjm";

  meta = with stdenv.lib; {
    homepage = http://www.paratype.ru/public/;
    description = "An open Paratype font";

    license = "Open Paratype license";
    # no commercial distribution of the font on its own
    # must rename on modification
    # http://www.paratype.ru/public/pt_openlicense.asp

    platforms = platforms.all;
    maintainers = with maintainers; [ raskin ];
  };
}

