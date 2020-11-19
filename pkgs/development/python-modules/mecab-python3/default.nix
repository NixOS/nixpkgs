{ lib
, buildPythonPackage
, fetchPypi
, mecab
, swig
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eefdff160ba231acb21afab5c775bc2e024b3164c637a23b599b270d45feb32d";
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
