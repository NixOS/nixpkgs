{ lib
, bokeh
, buildPythonPackage
, colorcet
, fetchPypi
, ipython
, matplotlib
, notebook
, numpy
, pandas
, panel
, param
, pythonOlder
, pyviz-comms
, scipy
}:

buildPythonPackage rec {
  pname = "holoviews";
<<<<<<< HEAD
  version = "1.17.1";
=======
  version = "1.15.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-yjDGYVCLIunowRnbw+Sl2FGYe0PDBWXbGAspHY/XcKQ=";
=======
    hash = "sha256-StwTN1DmDnNiZ+3iF2NW5qMDFDiwkTZ8tPKzhN6ZrgM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    colorcet
    numpy
    pandas
    panel
    param
    pyviz-comms
  ];

  # tests not fully included with pypi release
  doCheck = false;

  pythonImportsCheck = [
    "holoviews"
  ];

  meta = with lib; {
    description = "Python data analysis and visualization seamless and simple";
    homepage = "https://www.holoviews.org/";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
