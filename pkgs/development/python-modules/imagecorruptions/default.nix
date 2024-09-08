{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  scikit-image,
  lib,
  opencv4,
}:

buildPythonPackage rec {
  pname = "imagecorruptions";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "044e173f24d5934899bdbf3596bfbec917e8083e507eed583ab217abebbe084d";
  };

  pythonRemoveDeps = [ "opencv-python" ];

  build-system = [ setuptools ];

  dependencies = [
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
