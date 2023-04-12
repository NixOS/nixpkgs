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
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JBs0qlxctqmImIL5QJsBgpA6LF0ZtCGL42Cc271f/fk=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
