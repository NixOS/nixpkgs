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
  version = "1.42.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb61e2456f59a9a4a259fbc08def6d01ba45a42da8eeaa97d00633b0ec5de71c";
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
