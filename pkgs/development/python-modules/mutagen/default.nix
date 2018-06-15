{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pycodestyle
, pyflakes
, pytest
, pkgs
}:

buildPythonPackage rec {
  pname = "mutagen";
  version = "1.40.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ppfmpf60c78p4yp7in3f8y1l1fd34a38vw9swpg2fl6hz7c58mj";
  };

  checkInputs = [
    pkgs.faad2 pkgs.flac pkgs.vorbis-tools pkgs.liboggz
    pkgs.glibcLocales pycodestyle pyflakes pytest hypothesis
  ];
  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "Python multimedia tagging library";
    homepage = https://mutagen.readthedocs.io/;
    license = licenses.lgpl2Plus;
  };
}
