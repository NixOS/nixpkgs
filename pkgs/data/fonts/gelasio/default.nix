{ lib, mkFont, fetchFromGitHub }:

mkFont {
  pname = "gelasio";
  version = "unstable-2018-08-12";

  src = fetchFromGitHub {
    owner = "SorkinType";
    repo = "Gelasio";
    rev = "5bced461d54bcf8e900bb3ba69455af35b0d2ff1";
    sha256 = "19vmdi9zy5rs52mwwwi88kcgpfnwqyz12kw19bz5hfwzjrr7jdsn";
  };

  meta = with lib; {
    description = "a font which is metric-compatible with Microsoft's Georgia";
    longDescription = ''
      Gelasio is an original typeface which is metrics compatible with Microsoft's
      Georgia in its Regular, Bold, Italic and Bold Italic weights. Interpolated
      Medium, medium Italic, SemiBold and SemiBold Italic have now been added as well.
    '';
    homepage = "https://github.com/SorkinType/Gelasio";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ colemickens ];
  };
}

