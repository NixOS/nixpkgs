{ lib
, buildPythonPackage
, fetchPypi
, numpy
, python
}:

buildPythonPackage rec {
  pname = "scikit-fmm";
  version = "2019.1.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb64b6d8e30b8df8f8636d5fc4fd7ca6a9b05938ccd62518c80c1d9e823069dd";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkPhase = ''
    mkdir testdir; cd testdir
    ${python.interpreter} -c "import skfmm, sys; sys.exit(skfmm.test())"
  '';

  meta = with lib; {
    description = "A Python extension module which implements the fast marching method";
    homepage = "https://github.com/scikit-fmm/scikit-fmm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
