{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  scikit-image,
  lib,
  opencv-python,
}:

buildPythonPackage (finalAttr: {
  pname = "imagecorruptions";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bethgelab";
    repo = "imagecorruptions";
    tag = "v${finalAttr.version}";
    hash = "sha256-xAFBFe6D0lspenDwa7Sly+/QWBQiAfuNUf3ZuaYqD54=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scikit-image
    opencv-python
  ];

  doCheck = false;
  pythonImportsCheck = [ "imagecorruptions" ];

  meta = {
    homepage = "https://github.com/bethgelab/imagecorruptions";
    description = "This package provides a set of image corruptions";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
})
