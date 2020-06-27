{ lib, mkFont, fetchurl, unzip }:

mkFont {
  pname = "paratype-pt-sans";
  version = "2017-04-16";

  src = fetchurl {
    urls = [
      "https://company.paratype.com/system/attachments/629/original/ptsans.zip"
      "http://rus.paratype.ru/system/attachments/629/original/ptsans.zip"
    ];
    sha256 = "1j9gkbqyhxx8pih5agr9nl8vbpsfr9vdqmhx73ji3isahqm3bhv5";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";

  meta = with lib; {
    homepage = "http://www.paratype.ru/public/";
    description = "An open Paratype font";

    license = "Open Paratype license";
    # no commercial distribution of the font on its own
    # must rename on modification
    # http://www.paratype.ru/public/pt_openlicense.asp

    platforms = platforms.all;
    maintainers = with maintainers; [ raskin ];
  };
}

