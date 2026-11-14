{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pillow,
  django,
  six,
}:

let
  pname = "image";
  version = "1.5.34";
in
buildPythonPackage rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OM5GpN1/IIH4d5gIRW/cxW7DST1Q5jb83gzDxtZWDko=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    pillow
    django
    six
  ];

  pythonImportsCheck = [ "image" ];

  meta = {
    description = "Django application for image and video processing";
    homepage = "https://github.com/francescortiz/image";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
}
