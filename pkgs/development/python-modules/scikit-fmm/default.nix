{ lib
, buildPythonPackage
, fetchPypi
, numpy
, python
}:

buildPythonPackage rec {
  pname = "scikit-fmm";
  version = "2023.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-14ccR/ggdyq6kvJWUe8U5NJ96M45PArjwCqzxuJCPAs=";
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
    maintainers = with maintainers; [ ];
  };
}
