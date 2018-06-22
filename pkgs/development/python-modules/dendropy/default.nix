{ lib
, pkgs
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "DendroPy";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0a0e2ce78b3ed213d6c1791332d57778b7f63d602430c1548a5d822acf2799c";
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
