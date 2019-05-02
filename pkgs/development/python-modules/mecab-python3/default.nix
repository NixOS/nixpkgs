{ lib
, buildPythonPackage
, fetchPypi
, mecab
, swig
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "0.996.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a80383fba343dad247b486a9afa486b7f0ec6244cb8bbf2d6a24d2fab5f19180";
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
