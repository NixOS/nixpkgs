{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "norwester";
  version = "1.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://jamiewilson.io/norwester/assets/norwester.zip";
    sha256 = "0syg8ss7mpli4cbxvh3ld7qrlbhb2dfv3wchm765iw6ndc05g92d";
  };

  phases = [ "installPhase" ];

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    unzip -D -j $src ${pname}-v${version}/${pname}.otf -d $out/share/fonts/opentype/
  '';

  meta = with stdenv.lib; {
    homepage = http://jamiewilson.io/norwester;
    description = "A condensed geometric sans serif by Jamie Wilson";
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
