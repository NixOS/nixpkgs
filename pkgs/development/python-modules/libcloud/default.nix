{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycrypto,
  requests,
}:

buildPythonPackage rec {
  pname = "apache-libcloud";
  version = "3.8.0";
  format = "setuptools";

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

  meta = {
    description = "Unified interface to many cloud providers";
    homepage = "https://libcloud.apache.org/";
    changelog = "https://github.com/apache/libcloud/blob/v${version}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
