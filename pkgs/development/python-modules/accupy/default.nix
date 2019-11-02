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
  version = "0.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e27ca7eed8a1bde2e6e040f8f3ee94a5d7522f42c4360756c9ec8931cf13ca98";
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
