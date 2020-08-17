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
  version = "0.12.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "185d93588c4cc150b2426b2764cdf2370f1807c607c1b4b057c66b2a08720c43";
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
