{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools-scm,
  pillow,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "python-barcode";
  version = "0.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oxgl+9sR5ZdGbf9ChrTqmx6GpXcXtZ5WOuZ5cm/IVN4=";
  };

  propagatedBuildInputs = [ setuptools-scm ];

  optional-dependencies = {
    images = [ pillow ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ]
  ++ optional-dependencies.images;

  pythonImportsCheck = [ "barcode" ];

  meta = with lib; {
    description = "Create standard barcodes with Python";
    mainProgram = "python-barcode";
    homepage = "https://github.com/WhyNotHugo/python-barcode";
    changelog = "https://github.com/WhyNotHugo/python-barcode/blob/v${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
