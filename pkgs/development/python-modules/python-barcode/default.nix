{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, pillow
, pytestCheckHook
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

  propagatedBuildInputs = [
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    images = [
      pillow
    ];
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=barcode" "" \
      --replace "--cov-report=term-missing:skip-covered" "" \
      --replace "--no-cov-on-fail" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.images;

  pythonImportsCheck = [ "barcode" ];

  meta = with lib; {
    description = "Create standard barcodes with Python";
    homepage = "https://github.com/WhyNotHugo/python-barcode";
    changelog = "https://github.com/WhyNotHugo/python-barcode/blob/v${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
