{ lib, mkFont, fetchurl, unzip }:

mkFont {
  pname = "paratype-pt-mono";
  version = "2017-04-16";

  src = fetchurl {
    urls = [
      "https://company.paratype.com/system/attachments/631/original/ptmono.zip"
      "http://rus.paratype.ru/system/attachments/631/original/ptmono.zip"
    ];
    sha256 = "1wqaai7d6xh552vvr5svch07kjn1q89ab5jimi2z0sbd0rbi86vl";
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

