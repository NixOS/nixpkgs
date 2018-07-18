{ stdenv, fetchzip }:
fetchzip rec {
  name = "fontin-sans";

  url = http://www.exljbris.com/dl/FontinSans_49.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "04q01kqx9jq7snjfgd4x4dbr3ff756x5zwwn5ls69d8gsfzfmb6n";

  meta = with stdenv.lib; {
    homepage = https://www.exljbris.com/fontinsans.html;
    description = "The Fontin Sans free font";
    longDescription = ''
      This font is a suitable sans companion of Fontin. With a nice classical appearance it will be a perfect match.
    '';
    license = https://www.exljbris.com/eula.html;
    platforms = platforms.all;
    maintainers = with maintainers; [ mredaelli ];
  };
}
