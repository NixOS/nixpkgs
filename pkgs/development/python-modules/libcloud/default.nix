{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycrypto,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "3.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-db9MCxI7wiXiTKlfyhw1vjCxnmu4X+6ngUBNQ8QnbJE=";
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

  pythonImportsCheck = [ "libcloud" ];

  meta = with lib; {
    description = "A unified interface to many cloud providers";
    homepage = "https://libcloud.apache.org/";
    changelog = "https://github.com/apache/libcloud/blob/v${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
