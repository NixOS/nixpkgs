{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "aurulent-sans";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "deepfire";
    repo = "hartke-aurulent-sans";
    rev = "${pname}-${version}";
    sha256 = "01hvpvbrks40g9k1xr2f1gxnd5wd0sxidgfbwrm94pdi1a36xxrk";
  };

  meta = {
    description = "Aurulent Sans";
    longDescription = "Aurulent Sans is a humanist sans serif intended to be used as an interface font.";
    homepage = "http://delubrum.org/";
    maintainers = with lib.maintainers; [ deepfire ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
