{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, imagesSupport ? false
, pillow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-barcode";
  version = "0.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+vukqiTp2Wl3e+UhwpT/GPbCs2rWO1/C8hCNly4jslI=";
  };

  propagatedBuildInputs = [
    setuptools-scm
  ] ++ lib.optionals (imagesSupport) [
    pillow
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=barcode" "" \
      --replace "--cov-report=term-missing:skip-covered" "" \
      --replace "--no-cov-on-fail" ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "barcode" ];

  meta = with lib; {
    description = "Create standard barcodes with Python";
    homepage = "https://github.com/WhyNotHugo/python-barcode";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
