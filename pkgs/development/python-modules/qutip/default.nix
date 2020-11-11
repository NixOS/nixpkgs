{ stdenv
, lib
, python
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptoolsBuildHook
, gcc
, hypothesis
, numpy
, scipy
, matplotlib
, cython
, pytest
}:

buildPythonPackage rec {
  pname = "qutip";
  version = "4.5.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "18iz5wyixyj6v559my6rgi1w1gxg7b3wm5lfavkjz3ldjhd9m8sn";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "cython>=0.21" "cython" \
      --replace "numpy>=1.12" "numpy" \
      --replace "scipy>=1.0" "scipy"
  '';

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    cython
  ];

  nativeBuildInputs = [ numpy scipy cython pytest setuptoolsBuildHook ];

  enableParallelBuilding = true;

  doCheck = true;

  checkInputs = [ hypothesis ];

  checkPhase = ''
    runHook preCheck
    pushd dist
    ${python.interpreter} -c 'import numpy; numpy.test("fast", verbose=10)'
    popd
    runHook postCheck
  '';

  meta = with lib; {
    description = "Quantum Toolbox in Python";
    homepage = "https://qutip.org";
    changelog = "http://qutip.org/docs/latest/changelog.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mcncm ];
  };
}
