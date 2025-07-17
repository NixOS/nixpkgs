{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, cffi
, srtp
}:
buildPythonPackage rec {
  pname = "pylibsrtp";
  version = "0.7.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4a5BXvH5Z7oICpVRvpoHJs4F2PTNksEJXauA7WkuxXc=";
  };
  nativeBuildInputs = [ setuptools cffi ];
  buildInputs = [ srtp ];
  propagatedBuildInputs = [ cffi ];
  pythonImportsCheck = [ "pylibsrtp" ];
  meta = {
    description = "Python bindings for libsrtp";
    homepage = "https://github.com/aiortc/pylibsrtp";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sdubey ];
  };
}
