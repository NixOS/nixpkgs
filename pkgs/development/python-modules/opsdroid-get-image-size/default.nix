{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
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

  nativeBuildInputs = [ setuptools ];

  # test data not included on pypi
  doCheck = false;

  pythonImportsCheck = [ "get_image_size" ];

  meta = with lib; {
    description = "Get image width and height given a file path using minimal dependencies";
    mainProgram = "get-image-size";
    license = licenses.mit;
    homepage = "https://github.com/opsdroid/image_size";
    maintainers = with maintainers; [ globin ];
  };
}
