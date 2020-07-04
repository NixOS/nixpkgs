{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, pytestrunner
, pytest
, h5py
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "0.12.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1253f1d85bda79a45d209ea467e4ba6fcaa5354c317c194945dc354a259f5aa8";
  };

  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [ pandas pytest h5py ];
  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Manipulate jagged, chunky, and/or bitmasked arrays as easily as Numpy";
    homepage = "https://github.com/scikit-hep/awkward-array";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
