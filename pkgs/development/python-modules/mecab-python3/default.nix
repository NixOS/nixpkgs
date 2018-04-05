{ lib
, buildPythonPackage
, mecab
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "007dg4f5fby2yl7cc44x6xwvcrf2w2ifmn0rmk56ss33mhs8l6qy";
  };

  propagatedBuildInputs = [ mecab ];

  meta = with lib; {
    description = "A python wrapper for mecab: Morphological Analysis engine";
    homepage =  https://github.com/LuminosoInsight/wordfreq/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ ixxie ];
  };
}
