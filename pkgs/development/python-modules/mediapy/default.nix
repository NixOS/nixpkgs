{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, ipython
, matplotlib
, numpy
, pillow
}:

buildPythonPackage rec {
  pname = "mediapy";
  version = "1.0.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cM8u27XSN4VzXONk+tQElZgT5XdShWXq0UtDg5JbF9o=";
  };

  propagatedBuildInputs = [ ipython matplotlib numpy pillow ];

  pythonImportsCheck = [ "mediapy" ];

  meta = with lib; {
    description = "Read/write/show images and videos in an IPython notebook";
    homepage = "https://github.com/google/mediapy";
    license = licenses.asl20;
    maintainers = with maintainers; [ mcwitt ];
  };
}
