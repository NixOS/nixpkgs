{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "paratype-pt-sans";

  src = fetchurl rec {
    url = "http://www.paratype.ru/uni/public/PTSans.zip";
    sha256 = "1j9gkbqyhxx8pih5agr9nl8vbpsfr9vdqmhx73ji3isahqm3bhv5";
  };

  buildInputs = [unzip];

  phases = "unpackPhase installPhase";
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/paratype
    cp *.ttf $out/share/fonts/truetype
    cp *.txt $out/share/doc/paratype
  '';

  meta = with stdenv.lib; {
    homepage = http://www.paratype.ru/public/; 
    description = "An open Paratype font";

    license = "Open Paratype license"; 
    # no commercial distribution of the font on its own
    # must rename on modification
    # http://www.paratype.ru/public/pt_openlicense.asp

    platforms = platforms.all;
    maintainers = with maintainers; [ raskin ];
  };
}

