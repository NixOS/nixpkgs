{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "freepats-20060219";

  src = fetchurl {
    url = "https://freepats.zenvoid.org/${name}.tar.bz2";
    sha256 = "12iw36rd94zirll96cd5k0va7p5hxmf2shvjlhzihcmjaw8flq82";
  };

  installPhase = ''mkdir "$out"; cp -r . "$out"'';

  meta = with stdenv.lib; {
    description = "Instrument patches, for MIDI synthesizers";
    longDescription = ''
      Freepats is a project to create a free and open set of instrument
      patches, in any format, that can be used with softsynths.
    '';
    homepage = "http://freepats.zenvoid.org/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
