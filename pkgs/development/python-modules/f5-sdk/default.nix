{ lib
, buildPythonPackage
, fetchPypi
, f5-icontrol-rest
, six
}:

buildPythonPackage rec {
  pname = "f5-sdk";
  version = "3.0.21";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IokMj9mCMsFMVFYO4CpZUB2i32cOamhS5u2mNkNjljo=";
  };

  propagatedBuildInputs = [
    f5-icontrol-rest
    six
  ];

  # needs to be updated to newer pytest version and requires physical device
  doCheck = false;

  pythonImportsCheck = [ "f5" ];

  meta = with lib; {
    description = "F5 Networks Python SDK";
    homepage = "https://github.com/F5Networks/f5-common-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
