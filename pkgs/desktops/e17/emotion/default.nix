{ stdenv, fetchurl, pkgconfig, ecore, evas, eet, eina, edje }:
stdenv.mkDerivation rec {
  name = "emotion-${version}";
  version = "1.7.5";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "1sfw8kpj2fcqymzd6q7p51xxib1n2arvjl1hnwhqkvwhlsq2b4sw";
  };
  buildInputs = [ pkgconfig ecore evas eet eina edje ];
  meta = {
    description = "A library to easily integrate media playback into EFL applications";
    longDescription = ''
      Emotion is a library to easily integrate media playback into EFL applications,
      it will take care of using Ecore's main loop and video display is done using Evas.
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.lgpl21;
  };
}
