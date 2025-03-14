{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "opsdroid-get-image-size";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

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

  meta = with lib; {
    description = "Get image width and height given a file path using minimal dependencies";
    homepage = "https://github.com/opsdroid/image_size";
    changelog = "https://github.com/opsdroid/image_size/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
    mainProgram = "get-image-size";
  };
}
