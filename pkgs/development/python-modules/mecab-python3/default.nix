{ lib
, buildPythonPackage
, fetchPypi
, mecab
, swig
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "0.996.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5aca4d0d196161e41452b89921042c0e61a6b7e7e9373211c0c1c50d1809055d";
  };

  nativeBuildInputs = [
    mecab # for mecab-config
    swig
  ];

  buildInputs = [ mecab ];

  meta = with lib; {
    description = "A python wrapper for mecab: Morphological Analysis engine";
    homepage =  https://github.com/SamuraiT/mecab-python3;
    license = with licenses; [ gpl2 lgpl21 bsd3 ]; # any of the three
    maintainers = with maintainers; [ ixxie ];
  };
}
