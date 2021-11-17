{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, mock
, pycrypto
, requests
, pytest-runner
, pytest
, requests-mock
, typing
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17618ccbe3493f2be015db9e1efa35080ff34d470de723f1384d908ff126e51c";
  };

  checkInputs = [ mock pytest pytest-runner requests-mock ];
  propagatedBuildInputs = [ pycrypto requests ] ++ lib.optionals isPy27 [ typing ];

  preConfigure = "cp libcloud/test/secrets.py-dist libcloud/test/secrets.py";

  # requires a certificates file
  doCheck = false;

  pythonImportsCheck = [ "libcloud" ];

  meta = with lib; {
    description = "A unified interface to many cloud providers";
    homepage = "https://libcloud.apache.org/";
    changelog = "https://github.com/apache/libcloud/blob/v${version}/CHANGES.rst";
    license = licenses.asl20;
  };

}
