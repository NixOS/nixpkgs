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
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7016dc02d15b8797b59a461ccc8d218f37c335b97fa6b376638c0edd4ffc9de2";
  };

  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [ pytest h5py ];
  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Manipulate jagged, chunky, and/or bitmasked arrays as easily as Numpy";
    homepage = https://github.com/scikit-hep/awkward-array;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
