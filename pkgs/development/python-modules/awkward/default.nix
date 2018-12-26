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
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc824882f80ae07d442a011eb6d14a6fce581e022d4ff6c73d89d93c832ee3cc";
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
