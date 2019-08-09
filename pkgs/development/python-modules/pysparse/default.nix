{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, setuptools
, liblapack
, isPy27
, python
}:

buildPythonPackage rec {
  pname = "pysparse";
  version = "1.3-dev";
  disabled = !isPy27;

  src = fetchFromGitHub {
    owner = "PythonOptimizers";
    repo = "pysparse";
    rev = "f8430bd99ac2a6209c462657c5792d10033888cc";
    sha256 = "19xcq8214yndra1xjhna3qjm32wprsqck97dlnw3xcww7rfy6hqh";
  };

  hardeningDisable = [ "all" ];

  propagatedBuildInputs = [
    numpy
    numpy.blas
    liblapack
  ];

  # Include patches from working version of PySparse 1.3-dev in
  # Conda-Forge,
  # https://github.com/conda-forge/pysparse-feedstock/tree/b69266911a2/recipe
  # Thanks to https://github.com/guyer
  patches = [ ./dropPackageLoader.patch ];

  checkPhase = ''
    cd test
    ${python.interpreter} -c "import pysparse"
    ${python.interpreter} test_sparray.py
  '';

  meta = with lib; {
    homepage = https://github.com/PythonOptimizers/pysparse;
    description = "A Sparse Matrix Library for Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
