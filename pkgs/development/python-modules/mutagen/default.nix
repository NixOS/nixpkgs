{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, fetchpatch
, flake8
, hypothesis
, pycodestyle
, pyflakes
, pytest
, setuptools
, pkgs
}:

buildPythonPackage rec {
  pname = "mutagen";
  version = "1.45.1";
  disabled = isPy27; # abandoned

  src = fetchPypi {
    inherit pname version;
    sha256 = "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1";
  };

  requiredPythonModules = [ setuptools ];
  checkInputs = [
    pkgs.faad2 pkgs.flac pkgs.vorbis-tools pkgs.liboggz
    pkgs.glibcLocales pycodestyle pyflakes pytest hypothesis flake8
  ];
  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "Python multimedia tagging library";
    homepage = "https://mutagen.readthedocs.io";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
