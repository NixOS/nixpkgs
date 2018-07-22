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
  version = "1.41.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dab6038c7f0e17c1b67fb8f56303e8be21e73ac47760f1a8e716856f1bdf5057";
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
