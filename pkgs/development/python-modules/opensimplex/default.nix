{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "opensimplex";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aqpksbwf52s3w2adz467df474prcqxazdq6nic63kdf1zhjpwak";
  };

  # Error "make: *** No rule to make target 'test'.  Stop."
  doCheck = false;

  checkPhase = ''
    make test
    make benchmark
  '';

  meta = with lib; {
    description = "Python port of Kurt Spencer's OpenSimplex Noise functions for 2D, 3D and 4D.";
    homepage = "https://github.com/lmas/opensimplex";
    license = licenses.mit;
    maintainers = with maintainers; [ mrmebelman ];
  };
}

