{ buildFontPackage, fetchzip, lib }:

buildFontPackage rec {
  pname = "3270font";
  version = "2.0.4";

  src = fetchzip {
    url = "https://github.com/rbanffy/3270font/releases/download/v${version}/3270_fonts_ece94f6.zip";
    sha256 = "18mffq99lkbx8gprxqh0r9jv6vh7aqcmcy68ylpgbqkz2f86zlxc";
    stripRoot=false;
  };

  meta = with lib; {
    description = "Monospaced font based on IBM 3270 terminals";
    homepage = "https://github.com/rbanffy/3270font";
    license = [ licenses.bsd3 licenses.ofl ];
    maintainers = [ maintainers.marsam ];
  };
}
