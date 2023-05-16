{ lib
, bottleneck
, buildPythonPackage
, fetchPypi
, jellyfish
, joblib
, networkx
, numexpr
, numpy
, pandas
, pyarrow
, pytest
<<<<<<< HEAD
, pythonOlder
, scikit-learn
, scipy
, setuptools
, setuptools-scm
=======
, scikit-learn
, scipy
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "recordlinkage";
<<<<<<< HEAD
  version = "0.16";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7NoMEN/xOLFwaBXeMysShfZwrn6MzpJZYhNQHVieaqQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

=======
  version = "0.15";

  disabled = pythonOlder "3.7";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aIrx54vnf85I/Kit/4njg/VIOu6H0SE7NdQ1GbeP8Cc=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    pyarrow
    jellyfish
    numpy
    pandas
    scipy
    scikit-learn
    joblib
    networkx
    bottleneck
    numexpr
  ];

  # pytestCheckHook does not work
  # Reusing their CI setup which involves 'rm -rf recordlinkage' in preCheck phase do not work too.
<<<<<<< HEAD
  nativeCheckInputs = [
    pytest
  ];

  pythonImportsCheck = [
    "recordlinkage"
  ];
=======
  nativeCheckInputs = [ pytest ];

  pythonImportsCheck = [ "recordlinkage" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Library to link records in or between data sources";
    homepage = "https://recordlinkage.readthedocs.io/";
<<<<<<< HEAD
    changelog = "https://github.com/J535D165/recordlinkage/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raitobezarius ];
=======
    license = licenses.bsd3;
    maintainers = [ maintainers.raitobezarius ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
