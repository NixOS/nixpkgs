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
<<<<<<< HEAD
  version = "1.1.8";
=======
  version = "1.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-mVhBM+NQEkLYByp/kCPFJCAY26La5CWjcPl6PgclA9A=";
=======
    hash = "sha256-n0S3YEAJZNi+pRIaIT+U3JoiXQJtaoGZASg6aV5YVjQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
