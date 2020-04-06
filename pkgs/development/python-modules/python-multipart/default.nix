{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
, mock
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "python-multipart";
  version = "0.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7bb5f611fc600d15fa47b3974c8aa16e93724513b49b5f95c81e6624c83fa43";
  };

  checkInputs = [
    pytest
    pytestcov
    mock
    pyyaml
  ];

  propagatedBuildInputs = [
    six
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A streaming multipart parser for Python";
    homepage = https://github.com/andrew-d/python-multipart;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
