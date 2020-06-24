{ lib, mkFont, fetchurl, unzip }:

mkFont {
  pname = "paratype-pt-serif";
  version = "2017-04-16";

  src = fetchurl {
    urls = [
      "https://company.paratype.com/system/attachments/634/original/ptserif.zip"
      "http://rus.paratype.ru/system/attachments/634/original/ptserif.zip"
    ];
    sha256 = "0x3l58c1rvwmh83bmmgqwwbw9av1mvvq68sw2hdkyyihjvamyvvs";
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

