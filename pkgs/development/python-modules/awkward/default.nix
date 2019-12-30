{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, pyarrow
, pytestrunner
, pytest
, h5py
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "0.12.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b3df4f2be92ac7d16709f15769c97591f25f0442061f1a4cc8715feb268e45c";
  };

  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [ pandas pyarrow pytest h5py ];
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
