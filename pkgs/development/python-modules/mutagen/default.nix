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
  version = "1.41.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ea9c900a05fa7f5f4c5bd9fc1475d7d576532e13b2f79b694452b997ff67200";
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
