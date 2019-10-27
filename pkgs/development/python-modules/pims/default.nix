{ stdenv
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
  version = "0.4.1";
  pname = "PIMS";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a53a155e900b44e71127a1e1fccbfbaed7eec3c2b52497c40c23a05f334c9dd";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ slicerator six numpy tifffile scikitimage ];

  # not everything packaged with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/soft-matter/pims;
    description = "Python Image Sequence: Load video and sequential images in many formats with a simple, consistent interface";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
