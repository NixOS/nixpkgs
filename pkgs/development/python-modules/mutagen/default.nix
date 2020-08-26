{ lib
, buildPythonPackage
, fetchPypi
, isPy27
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
  version = "1.44.0";
  disabled = isPy27; # abandoned

  src = fetchPypi {
    inherit pname version;
    sha256 = "56065d8a9ca0bc64610a4d0f37e2bd4453381dde3226b8835ee656faa3287be4";
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
