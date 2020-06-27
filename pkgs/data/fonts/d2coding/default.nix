{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "d2codingfont";
  version = "1.3.2";

  src = fetchzip {
    url = "https://github.com/naver/${pname}/releases/download/VER${version}/D2Coding-Ver${version}-20180524.zip";
    sha256 = "081qc82d5gqs0dn32fc3wb1aqiqw712jai85vznqr0wm8ils4bl8";
    stripRoot = false;
  };

  meta = with lib; {
    description = "Monospace font with support for Korean and latin characters";
    longDescription = ''
      D2Coding is a monospace font developed by a Korean IT Company called Naver.
      Font is good for displaying both Korean characters and latin characters,
      as sometimes these two languages could share some similar strokes.
      Since verion 1.3, D2Coding font is officially supported by the font
      creator, with symbols for Powerline.
    '';
    homepage = "https://github.com/naver/d2codingfont";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
