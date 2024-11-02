{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  simplejson,
  pytz,
  requests,
}:

buildPythonPackage rec {
  pname = "etcd";
  version = "2.0.8";
  format = "setuptools";

  # PyPI package is incomplete
  src = fetchFromGitHub {
    owner = "dsoprea";
    repo = "PythonEtcdClient";
    rev = version;
    hash = "sha256-h+jYIRSNdrGkW3tBV1ifIDEXU46EQGyeJoz/Mxym4pI=";
  };

  postPatch = ''
    sed -i -e '13,14d;37d' setup.py
  '';

  propagatedBuildInputs = [
    simplejson
    pytz
    requests
  ];

  # No proper tests are available
  doCheck = false;

  meta = with lib; {
    description = "Python etcd client that just works";
    homepage = "https://github.com/dsoprea/PythonEtcdClient";
    license = licenses.gpl2;
    maintainers = [ ];
  };
}
