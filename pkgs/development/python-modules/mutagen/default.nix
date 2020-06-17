{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, hypothesis
, pycodestyle
, pyflakes
, pytest
, setuptools
, pkgs
}:

buildPythonPackage rec {
  pname = "mutagen";
  version = "1.43.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a982d39f1b800520a32afdebe3543f972e83a6ddd0c0198739a161ee705b588";
  };

  propagatedBuildInputs = [ setuptools ];
  checkInputs = [
    pkgs.faad2 pkgs.flac pkgs.vorbis-tools pkgs.liboggz
    pkgs.glibcLocales pycodestyle pyflakes pytest hypothesis
  ];
  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "Python multimedia tagging library";
    homepage = "https://mutagen.readthedocs.io";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
