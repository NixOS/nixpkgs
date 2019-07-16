{ lib
, buildPythonPackage
, fetchPypi
, mpmath
, numpy
, pipdate
, pybind11
, pyfma
, eigen
, pytest
, matplotlib
, perfplot
, isPy27
}:

buildPythonPackage rec {
  pname = "accupy";
  version = "0.1.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a67f2a778b824fb24eb338fed8e0b61c1af93369d57ff8132f5d602d60f0543";
  };

  buildInputs = [
    pybind11 eigen
  ];

  propagatedBuildInputs = [
    mpmath
    numpy
    pipdate
    pyfma
  ];

  checkInputs = [
    pytest
    matplotlib
    perfplot
  ];

  postConfigure = ''
   substituteInPlace setup.py \
     --replace "/usr/include/eigen3/" "${eigen}/include/eigen3/"
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  checkPhase = ''
    pytest test
  '';

  meta = with lib; {
    description = "Accurate sums and dot products for Python";
    homepage = https://github.com/nschloe/accupy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
