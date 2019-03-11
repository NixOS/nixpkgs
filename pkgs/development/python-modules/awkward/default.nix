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
  version = "0.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a53c484za2l4yy1i05qhkylvygg8fnh4j1v3n35x2dsi929awdp";
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
