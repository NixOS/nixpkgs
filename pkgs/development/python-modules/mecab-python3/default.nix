{ lib
, buildPythonPackage
, fetchPypi
, mecab
, swig
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b150ad5fe4260539b4ef184657e552ef81307fbbe60ae1f258bc814549ea90f8";
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
