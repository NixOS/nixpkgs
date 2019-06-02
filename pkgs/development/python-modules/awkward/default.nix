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
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vq27db5k8cc5jpbdrl531gjhig0f9iy0i7z6ks81lz1a2mkvjik";
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
