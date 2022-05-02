{ lib
, buildPythonPackage
, fetchPypi
, slicerator
, scikitimage
, six
, numpy
, tifffile
, nose
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "PIMS";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EQJ0LWQsi4rMcQ011QK11whe4SiMNhg3PvjEcgMLxoM=";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ slicerator six numpy tifffile scikitimage ];

  # not everything packaged with pypi release
  doCheck = false;
  pythonImportsCheck = [ "pims" ];

  meta = with lib; {
    homepage = "https://github.com/soft-matter/pims";
    description = "Python Image Sequence: Load video and sequential images in many formats with a simple, consistent interface";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
