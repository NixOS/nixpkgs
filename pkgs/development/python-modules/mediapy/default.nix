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
  version = "1.1.6";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n0S3YEAJZNi+pRIaIT+U3JoiXQJtaoGZASg6aV5YVjQ=";
  };

  propagatedBuildInputs = [ ipython matplotlib numpy pillow ];

  format = "flit";

  pythonImportsCheck = [ "mediapy" ];

  meta = with lib; {
    description = "Read/write/show images and videos in an IPython notebook";
    homepage = "https://github.com/google/mediapy";
    license = licenses.asl20;
    maintainers = with maintainers; [ mcwitt ];
  };
}
