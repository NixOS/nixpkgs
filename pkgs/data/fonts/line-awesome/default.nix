{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "line-awesome";
  version = "1.3.0";

  src = fetchzip {
    url = "https://maxst.icons8.com/vue-static/landings/line-awesome/line-awesome/${version}/line-awesome-${version}.zip";
    sha256 = "1sv517g8vpf1r58zczyqbbkfmajrypfilfblhqz9r2cw4rkfpwkb";
  };

  sourceRoot = "source/fonts";

  meta = with lib; {
    description = "Replace Font Awesome with modern line icons";
    longDescription = ''
      This package includes only the TTF, WOFF and WOFF2 fonts. For full CSS etc. see the project website.
    '';
    homepage = "https://icons8.com/line-awesome";
    license = licenses.mit;
    maintainers = with maintainers; [ puzzlewolf ];
    platforms = platforms.all;
  };
}
