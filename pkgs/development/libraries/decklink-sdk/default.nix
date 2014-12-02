{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "decklink-sdk-${version}";
  version = "10.1.4";

  src = fetchurl {
    url = "http://software.blackmagicdesign.com/SDK/Blackmagic_DeckLink_SDK_${version}.zip";
    sha256 = "0wzz4jxm5kb3i83piwih8lg7x20img7f3hm1zvzhjf2g8mx53m35";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/{Linux,Mac,Win}
    for i in Linux Mac Win; do
      cp -a $i/include $out/$i
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.blackmagicdesign.com/support;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
