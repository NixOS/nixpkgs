{ lib, fetchFromGitHub }:

let
  version = "6.6";
in fetchFromGitHub rec {
  name = "libertinus-${version}";

  owner  = "khaledhosny";
  repo   = "libertinus";
  rev    = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype *.otf
    install -m444 -Dt $out/share/doc/${name}    *.txt
  '';
  sha256 = "11pxb2zwvjlk06zbqrfv2pgwsl4awf68fak1ks4881i8xbl1910m";

  meta = with lib; {
    description = "A fork of the Linux Libertine and Linux Biolinum fonts";
    longDescription = ''
      Libertinus fonts is a fork of the Linux Libertine and Linux Biolinum fonts
      that started as an OpenType math companion of the Libertine font family,
      but grown as a full fork to address some of the bugs in the fonts.
    '';
    homepage = https://github.com/khaledhosny/libertinus;
    license = licenses.ofl;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
