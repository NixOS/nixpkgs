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
  version = "0.12.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s729a8205jzg7pfw8xgmi850x03p9nw8c6a602f5bnmhha96h45";
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
