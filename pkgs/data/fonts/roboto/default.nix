{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "roboto";
  version = "2.138";

  src = fetchzip {
    url = "https://github.com/google/roboto/releases/download/v${version}/roboto-unhinted.zip";
    sha256 = "0wa176l9718m39sm66iz0zpfb8fly2ddas18h4c9f1m7k18wzvdr";
    stripRoot = false;
  };

  meta = {
    homepage = "https://github.com/google/roboto";
    description = "The Roboto family of fonts";
    longDescription = ''
      Google’s signature family of fonts, the default font on Android and
      Chrome OS, and the recommended font for Google’s visual language,
      Material Design.
    '';
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
}
