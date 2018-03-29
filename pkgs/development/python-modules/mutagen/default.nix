{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pkgs
}:

buildPythonPackage rec {
  pname = "mutagen";
  version = "1.36";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kabb9b81hgvpd3wcznww549vss12b1xlvpnxg1r6n4c7gikgvnp";
  };

  checkInputs = [
    pkgs.faad2 pkgs.flac pkgs.vorbis-tools pkgs.liboggz
    pkgs.glibcLocales pytest
  ];
  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "Python multimedia tagging library";
    homepage = https://mutagen.readthedocs.io/;
    license = licenses.lgpl2;
  };
}
