{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
}:

buildPythonPackage rec {
  pname = "nose-randomly";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e483a3d79e13ae760d6ade57ae07ae45bb4b223b61a805e958b4c077116c67c";
  };

  checkInputs = [ numpy nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Nose plugin to randomly order tests and control random.seed";
    homepage = https://github.com/adamchainz/nose-randomly;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
