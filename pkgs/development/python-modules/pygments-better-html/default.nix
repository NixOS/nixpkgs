{ lib
, buildPythonPackage
, fetchPypi
, pygments
, isPy3k
}:

buildPythonPackage rec {
  pname = "pygments_better_html";
<<<<<<< HEAD
  version = "0.1.5";
=======
  version = "0.1.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-SLAe5ubIGEchUNoHCct6CWisBja3WNEfpE48v9CTzPQ=";
=======
    sha256 = "028szd3k295yhz943bj19i4kx6f0pfh1fd2q14id0g84dl4i49dm";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ pygments ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pygments_better_html" ];

  meta = with lib; {
    homepage = "https://github.com/Kwpolska/pygments_better_html";
    description = "Improved line numbering for Pygments’ HTML formatter.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
