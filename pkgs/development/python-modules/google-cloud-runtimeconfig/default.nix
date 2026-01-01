{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-core,
  mock,
  pytestCheckHook,
<<<<<<< HEAD
  setuptools,
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "google-cloud-runtimeconfig";
<<<<<<< HEAD
  version = "0.36.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_runtimeconfig";
    inherit version;
    hash = "sha256-+pDFyELolBTJfz/RIoNbGNHC30tyKhZ7D6XiQTKO2t0=";
  };

  build-system = [ setuptools ];

  dependencies = [
=======
  version = "0.34.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hyxvTChxCGC6YjjvYGqaJDvgBbve7EjzfPELl+LB2D8=";
  };

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    google-api-core
    google-cloud-core
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  # Client tests require credentials
  disabledTests = [ "client_options" ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud.runtimeconfig" ];

<<<<<<< HEAD
  meta = {
    description = "Google Cloud RuntimeConfig API client library";
    homepage = "https://github.com/googleapis/python-runtimeconfig";
    changelog = "https://github.com/googleapis/python-runtimeconfig/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Google Cloud RuntimeConfig API client library";
    homepage = "https://github.com/googleapis/python-runtimeconfig";
    changelog = "https://github.com/googleapis/python-runtimeconfig/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
