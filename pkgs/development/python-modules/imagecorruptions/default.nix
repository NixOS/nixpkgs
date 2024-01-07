{ buildPythonPackage
, fetchPypi
, numpy
, scikit-image
, lib
, opencv4
}:

buildPythonPackage rec {
  pname = "imagecorruptions";
  version = "1.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "044e173f24d5934899bdbf3596bfbec917e8083e507eed583ab217abebbe084d";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'opencv-python >= 3.4.5'," ""
  '';

  propagatedBuildInputs = [
    numpy
    scikit-image
    opencv4
  ];

  doCheck = false;
  pythonImportsCheck = [ "imagecorruptions" ];

  meta = with lib; {
    homepage = "https://github.com/bethgelab/imagecorruptions";
    description = "This package provides a set of image corruptions";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
