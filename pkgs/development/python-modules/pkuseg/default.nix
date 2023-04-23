{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pythonAtLeast
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "pkuseg";
  version = "0.0.25";

  disabled = !isPy3k || pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "148yp0l7h8cflxag62pc1iwj5b5liyljnaxwfjaiqwl96vwjn0fx";
  };

  # Does not seem to have actual tests, but unittest discover
  # recognizes some non-tests as tests and fails.
  doCheck = false;

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "pkuseg" ];

  meta = with lib; {
    description = "Toolkit for multi-domain Chinese word segmentation";
    homepage = "https://github.com/lancopku/pkuseg-python";
    license = licenses.unfree;
  };
}
