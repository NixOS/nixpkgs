{ lib
, pkgs
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "DendroPy";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd5b35ce1a1c9253209b7b5f3939ac22beaa70e787f8129149b4f7ffe865d510";
  };

  prePatch = ''
    # Test removed/disabled and reported upstream: https://github.com/jeetsukumaran/DendroPy/issues/74
    rm -f dendropy/test/test_dataio_nexml_reader_tree_list.py
  '';

  preCheck = ''
    # Needed for unicode python tests
    export LC_ALL="en_US.UTF-8"
  '';

  checkInputs = [ pkgs.glibcLocales ];

  meta = {
    homepage = http://dendropy.org/;
    description = "A Python library for phylogenetic computing";
    maintainers = with lib.maintainers; [ unode ];
    license = lib.licenses.bsd3;
  };
}
