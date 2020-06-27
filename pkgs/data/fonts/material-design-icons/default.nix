{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "material-design-icons";
  version = "4.7.95";

  src = fetchFromGitHub {
    owner  = "Templarian";
    repo   = "MaterialDesign-Webfont";
    rev    = "v${version}";
    sha256 = "1509r16hn72j83yz5hbdv23c71svj34wxgdnsd5l9gfzg84wyy0r";
  };

  meta = with lib; {
    description = "3200+ Material Design Icons from the Community";
    longDescription = ''
      Material Design Icons' growing icon collection allows designers and
      developers targeting various platforms to download icons in the format,
      color and size they need for any project.
    '';
    homepage = "https://materialdesignicons.com";
    license = with licenses; [
      asl20  # for icons from: https://github.com/google/material-design-icons
      ofl
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ vlaci ];
  };
}
