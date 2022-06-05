{ lib, buildPythonPackage, fetchPypi, python
, mock
, purl
, requests
, six
, testrepository
, testtools
, pytest
}:

buildPythonPackage rec {
  pname = "requests-mock";
  version = "1.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d72abe54546c1fc9696fa1516672f1031d72a55a1d66c85184f972a24ba0eba";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  propagatedBuildInputs = [ requests six ];

  checkInputs = [ mock purl testrepository testtools pytest ];

  meta = with lib; {
    description = "Mock out responses from the requests package";
    homepage = "https://requests-mock.readthedocs.io";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
