{ buildPythonPackage
, fetchPypi
, numpy
, scikitimage
, stdenv
, opencv3
}:

buildPythonPackage rec {
  pname = "imagecorruptions";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14j8x6axnyrn6y7bsjyh4yqm7af68mqpxy7gg2xh3d577d852zgm";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'opencv-python >= 3.4.5'," ""
  '';
  
  propagatedBuildInputs = [
    numpy
    scikitimage
    opencv3
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/bethgelab/imagecorruptions;
    description = "This package provides a set of image corruptions";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
