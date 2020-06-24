{ lib, buildPackages, mkFont, fetchzip }:

mkFont rec {
  version = "0.701";
  pname = "vegur-font";

    src = fetchzip {
    # Upstream doesn't version their URLs.
    # http://dotcolon.net/font/vegur/ → http://dotcolon.net/DL/font/vegur.zip
    url = "http://download.opensuse.org/repositories/M17N:/fonts/SLE_12_SP3/src/dotcolon-vegur-fonts-0.701-1.4.src.rpm";
    sha256 = "1w1csykf45hgiy7b7918qp6bqp4y3bq13cahi5cmx0zp8scgfrmh";
    postFetch = ''
      ${buildPackages.rpmextract}/bin/rpmextract $downloadedFile
      unzip vegur.zip -d $out
    '';
  };

  meta = with lib; {
    homepage = "http://dotcolon.net/font/vegur/";
    description = "A humanist sans serif font.";
    platforms = platforms.all;
    maintainers = [ maintainers.samueldr ];
    license = licenses.cc0;
  };
}
