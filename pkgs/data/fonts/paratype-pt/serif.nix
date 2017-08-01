{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "paratype-pt-serif";

  src = fetchurl rec {
    url = "http://www.paratype.ru/uni/public/PTSerif.zip";
    sha256 = "0x3l58c1rvwmh83bmmgqwwbw9av1mvvq68sw2hdkyyihjvamyvvs";
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

