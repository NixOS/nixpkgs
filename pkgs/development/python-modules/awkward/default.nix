{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytestrunner
, pytest
, h5py
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6b84d2356c8b1af955054bbef088c61bf87f68e062e866fa8d9ea5cb871389f";
  };

  buildInputs = [ pytestrunner h5py ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "Manipulate jagged, chunky, and/or bitmasked arrays as easily as Numpy.";
    homepage = https://github.com/scikit-hep/awkward-array;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
