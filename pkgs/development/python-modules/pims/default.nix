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
  version = "0.5";
  pname = "PIMS";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a02cdcbb153e2792042fb0bae7df4f30878bbba1f2d176114a87ee0dc18715a0";
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
