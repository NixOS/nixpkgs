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
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a461ee084ea5e98333dacf2506e9b2619ee89cece14b9b99830b546b35c5922";
  };

  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [ pandas pytest h5py ];
  requiredPythonModules = [ numpy ];

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
