{ lib
, buildPythonPackage
, fetchPypi
, mecab
, swig
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "0.996.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7f09caf136903ce908b8b001ffc178d6caa129c1550d47d8f7f733a213749a8";
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
    homepage =  "https://github.com/SamuraiT/mecab-python3";
    license = with licenses; [ gpl2 lgpl21 bsd3 ]; # any of the three
    maintainers = with maintainers; [ ixxie ];
  };
}
