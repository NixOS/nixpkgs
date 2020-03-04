{ lib
, buildPythonPackage
, fetchPypi
, mecab
, swig
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "0.996.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cedc968ef5bcbb2a6ece3bb4eb26e9569d89f3277dc2066ea0ce1341ab7d3b9";
  };

  nativeBuildInputs = [
    mecab # for mecab-config
    swig
    setuptools_scm
  ];

  buildInputs = [ mecab ];

  doCheck = false;

  meta = with lib; {
    description = "A python wrapper for mecab: Morphological Analysis engine";
    homepage =  https://github.com/SamuraiT/mecab-python3;
    license = with licenses; [ gpl2 lgpl21 bsd3 ]; # any of the three
    maintainers = with maintainers; [ ixxie ];
  };
}
