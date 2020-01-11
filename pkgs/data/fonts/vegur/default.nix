{ lib, buildPackages, fetchzip }:

let
  version = "0.701";
in fetchzip {
  name = "vegur-font-${version}";

  # Upstream doesn't version their URLs.
  # http://dotcolon.net/font/vegur/ → http://dotcolon.net/DL/font/vegur.zip
  url = "http://download.opensuse.org/repositories/M17N:/fonts/SLE_12_SP3/src/dotcolon-vegur-fonts-0.701-1.4.src.rpm";

  postFetch = ''
    ${buildPackages.rpmextract}/bin/rpmextract $downloadedFile
    unzip vegur.zip
    install -m444 -Dt $out/share/fonts/Vegur *.otf
  '';
  sha256 = "0iisi2scq72lyj7pc1f36fhfjnm676n5byl4zaavhbxpdrbc6d1v";

  meta = with lib; {
    homepage = http://dotcolon.net/font/vegur/;
    description = "A humanist sans serif font.";
    platforms = platforms.all;
    maintainers = [ maintainers.samueldr ];
    license = licenses.cc0;
  };
}
