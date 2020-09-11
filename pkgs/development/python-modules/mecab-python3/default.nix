{ lib
, buildPythonPackage
, fetchPypi
, mecab
, swig
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0246wxfk8v1js75nv8jl15cwpf4rvv4xndi4gbzjrrqbsgj2fvfm";
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
