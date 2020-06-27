{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "libertinus";
  version = "6.9";

  src = fetchFromGitHub {
    owner = "alif-type";
    repo = "libertinus";
    rev = "v${version}";
    sha256 = "1996qfc9x23f4xxxyc02nc3z1fcnbaqv6awfhz17hi0544qpz5d2";
  };

  meta = with lib; {
    description = "A fork of the Linux Libertine and Linux Biolinum fonts";
    longDescription = ''
      Libertinus fonts is a fork of the Linux Libertine and Linux Biolinum fonts
      that started as an OpenType math companion of the Libertine font family,
      but grown as a full fork to address some of the bugs in the fonts.
    '';
    homepage = "https://github.com/alif-type/libertinus";
    license = licenses.ofl;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
