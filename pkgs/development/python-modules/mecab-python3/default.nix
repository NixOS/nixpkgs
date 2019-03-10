{ lib
, buildPythonPackage
, mecab
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "0.996.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5aca4d0d196161e41452b89921042c0e61a6b7e7e9373211c0c1c50d1809055d";
  };

  propagatedBuildInputs = [ mecab ];

  meta = with lib; {
    description = "A python wrapper for mecab: Morphological Analysis engine";
    homepage =  https://github.com/LuminosoInsight/wordfreq/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ ixxie ];
  };
}
