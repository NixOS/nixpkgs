<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, pytestCheckHook
, scipy
, setuptools
, tables
=======
{ lib, buildPythonPackage, fetchPypi, isPy27
, numpy
, scipy
, tables
, pandas
, nose
, configparser
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "flammkuchen";
<<<<<<< HEAD
  version = "1.0.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z68HBsU9J6oe8+YL4OOQiMYQRs3TZUDM+e2ssqo6BFI=";
  };

  nativeBuildInputs = [
    setuptools
=======
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KtMGQftoYVNNMtfYeYiaQyMLAySpf9YXLMxj+e/CV5I=";
  };

  nativeCheckInputs = [
    nose
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    tables
<<<<<<< HEAD
  ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
  ];
=======
    pandas
  ] ++ lib.optionals isPy27 [ configparser ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    homepage = "https://github.com/portugueslab/flammkuchen";
    description = "Flexible HDF5 saving/loading library forked from deepdish (University of Chicago) and maintained by the Portugues lab";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
