{ lib
, buildPythonPackage
, fetchPypi
, pytest
, mock
, numpy
, multipledispatch
, dateutil
}:

buildPythonPackage rec {
  pname = "datashape";
  version = "0.5.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2356ea690c3cf003c1468a243a9063144235de45b080b3652de4f3d44e57d783";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ numpy multipledispatch dateutil ];

  checkPhase = ''
    py.test datashape/tests
  '';

  meta = {
    homepage = https://github.com/ContinuumIO/datashape;
    description = "A data description language";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fridh ];
  };
}