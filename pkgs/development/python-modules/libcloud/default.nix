{ lib
, buildPythonPackage
, fetchPypi
, pycrypto
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "3.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SjuRQQM3mOT7B4hv8mJU5jXgIqy91wg3XqxvVuMjUGw=";
  };

  propagatedBuildInputs = [
    pycrypto
    requests
  ];

  preConfigure = ''
    cp libcloud/test/secrets.py-dist libcloud/test/secrets.py
  '';

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setup_requires=pytest_runner," "setup_requires=[],"
  '';

  # requires a certificates file
  doCheck = false;

  pythonImportsCheck = [
    "libcloud"
  ];

  meta = with lib; {
    description = "A unified interface to many cloud providers";
    homepage = "https://libcloud.apache.org/";
    changelog = "https://github.com/apache/libcloud/blob/v${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
