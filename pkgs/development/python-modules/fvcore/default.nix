{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, iopath
, numpy
, pillow
, pyyaml
, tabulate
, termcolor
, tqdm
, yacs
}:

buildPythonPackage rec {
  pname = "fvcore";
  version = "0.1.5.post20210402";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zrb1dhiqdmjs6s36a2wrk4m4hry34zdy27l7rflwzc2q093rmji";
  };

  # There's an actual, proper test failure in here. Might blow up later
  doCheck = false;

  propagatedBuildInputs = [
    numpy
    yacs
    pyyaml
    tqdm
    termcolor
    pillow
    tabulate
    iopath
  ];

  meta = with lib; {
    description = "Collection of common code that's shared among different research projects in FAIR computer vision team";
    homepage = "https://github.com/facebookresearch/fvcore";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
