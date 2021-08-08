{ lib
, buildPythonPackage
, fetchPypi
, mecab
, swig
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62abe28a1155398325372291483608427bc82681fef80e7d132904415f9fd42e";
  };

  nativeBuildInputs = [
    mecab # for mecab-config
    swig
    setuptools-scm
  ];

  buildInputs = [ mecab ];

  doCheck = false;

  meta = with lib; {
    description = "A python wrapper for mecab: Morphological Analysis engine";
    homepage =  "https://github.com/SamuraiT/mecab-python3";
    license = with licenses; [ gpl2 lgpl21 bsd3 ]; # any of the three
    maintainers = with maintainers; [ ixxie ];
  };
}
