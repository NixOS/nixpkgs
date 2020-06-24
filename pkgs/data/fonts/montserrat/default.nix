{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "montserrat";
  version = "1.0";

  src = fetchzip {
    url = "https://marvid.fr/~eeva/mirror/Montserrat.tar.gz";
    sha256 = "09mr17gf2dnh2r10s5p6kgi34q7s4rwdqmmsvn1ysf8ljq4k7b5p";
  };

  meta = with lib; {
    description = "A geometric sans serif font with extended latin support (Regular, Alternates, Subrayada)";
    homepage    = "https://www.fontspace.com/julieta-ulanovsky/montserrat";
    license     = licenses.ofl;
    platforms   = platforms.all;
    maintainers = with maintainers; [ scolobb ];
  };
}
