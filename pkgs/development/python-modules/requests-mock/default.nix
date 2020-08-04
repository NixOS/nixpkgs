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
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e68f46844e4cee9d447150343c9ae875f99fa8037c6dcf5f15bf1fe9ab43d226";
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
