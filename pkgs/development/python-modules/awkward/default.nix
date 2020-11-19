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
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a3878f46e8bc2acf28a0b9feb69d354ad2fee2a2a0f65c48c115aa74f245204";
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
