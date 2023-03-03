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
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WcnDJBmp+xroPsJC2Y6InEW9fXpl1IN1zCQ+wIRBZYs=";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  propagatedBuildInputs = [ requests six ];

  nativeCheckInputs = [ mock purl testrepository testtools pytest ];

  meta = with lib; {
    description = "Mock out responses from the requests package";
    homepage = "https://requests-mock.readthedocs.io";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
