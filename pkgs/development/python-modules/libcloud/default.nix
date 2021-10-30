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
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7450453eaf5904eb4fb4f74cf9f37dc83721a719bce34f5abb336b1a1ab974d";
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
