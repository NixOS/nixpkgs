{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, nose
, scikitlearn
, scipy
, numba
, llvmlite
, joblib
}:

buildPythonPackage rec {
  pname = "pynndescent";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74a05a54d13573a38878781d44812ac6df97d8762a56f9bb5dd87a99911820fe";
  };

  patches = [
    # fixes tests, included in 0.5.2
    (fetchpatch {
      url = "https://github.com/lmcinnes/pynndescent/commit/ef5d8c3c3bfe976063b6621e3e0734c0c22d813b.patch";
      sha256 = "sha256-49n3kevs3wpzd4FfZVKmNpF2o1V8pJs4KOx8zCAhR3s=";
    })
  ];

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    scikitlearn
    scipy
    numba
    llvmlite
    joblib
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
