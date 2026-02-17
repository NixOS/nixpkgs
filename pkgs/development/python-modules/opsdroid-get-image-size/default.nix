{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "opsdroid-get-image-size";
  version = "0.2.2";
  pyproject = true;

  src = fetchPypi {
    pname = "opsdroid_get_image_size";
    inherit version;
    hash = "sha256-Cp2tvsdCZ+/86DF7FRNwx5diGcUWLYcFwQns7nYXkog=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ versioneer ];

  # Test data not included on PyPI
  doCheck = false;

  pythonImportsCheck = [ "get_image_size" ];

  meta = {
    description = "Get image width and height given a file path using minimal dependencies";
    homepage = "https://github.com/opsdroid/image_size";
    changelog = "https://github.com/opsdroid/image_size/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "get-image-size";
  };
}
