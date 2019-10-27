{ lib, buildPythonPackage, fetchPypi, python
, mock
, purl
, requests
, six
, testrepository
, testtools
}:

buildPythonPackage rec {
  pname = "requests-mock";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ij6ir5cy0gpy5xw4sykxz320ndi26np6flx9yg9mimkv0nl1lw8";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  propagatedBuildInputs = [ requests six ];

  checkInputs = [ mock purl testrepository testtools ];

  meta = with lib; {
    description = "Mock out responses from the requests package";
    homepage = "https://requests-mock.readthedocs.io";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
