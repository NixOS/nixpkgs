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
    dest=$out/share/fonts/truetype
    mkdir -p $dest
    find . -name "*.ttf" -exec cp -v {} $dest \;
    chmod -x $dest/*.ttf
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0q03gg0sh2mljlbmhamnxz28d13znh9dzca84p554s7pwg6z4wca";

  meta = with stdenv.lib; {
    homepage = https://www.google.com/fontsl;
    description = "Font files available from Google Font";
    license = with licenses; [ asl20 ofl ufl ];
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = with maintainers; [ manveru ];
  };
}
