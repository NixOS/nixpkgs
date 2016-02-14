{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "google-fonts";
  version = "2015-11-18";

  src = fetchurl {
    url = "https://github.com/google/fonts/archive/a26bc2b9f4ad27266c2587dc0355b3066519844a.tar.gz";
    sha256 = "1aizwzsxg30mjds1628280bs7ishgsfairnx131654gm51aihw8p";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    find . -name "*.ttf" -exec cp -v {} $out/share/fonts/truetype \;
  '';

  meta = with stdenv.lib; {
    homepage = https://www.google.com/fontsl;
    description = "Font files available from Google Font";
    license = with licenses; [ asl20 ofl ufl ];
    platforms = platforms.all;
    maintainers = with maintainers; [ manveru ];
  };
}
