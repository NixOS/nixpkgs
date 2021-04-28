{ lib
, buildPythonPackage
, fetchPypi
, nose
, scikitlearn
, scipy
, numba
, llvmlite
, joblib
}:

buildPythonPackage rec {
  pname = "pynndescent";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w87c2v0li2rdbx6qfc2lb6y6bxpdy3jwfgzfs1kcr4d1chj5zfr";
  };

  propagatedBuildInputs = [
    scikitlearn
    scipy
    numba
    llvmlite
    joblib
  ];

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Nearest Neighbor Descent";
    homepage = "https://github.com/lmcinnes/pynndescent";
    license = licenses.bsd2;
    maintainers = [ maintainers.mic92 ];
  };
}
