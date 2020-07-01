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
  version = "0.3.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b568de740e1cd137a96af1801b4d3d5f795e0f97be25c29957f39f004fbcdf9a";
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
    homepage = "https://github.com/nschloe/accupy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
