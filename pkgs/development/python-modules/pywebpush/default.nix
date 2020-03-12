{ lib, fetchPypi, buildPythonPackage
, coverage, flake8, mock, nose
, http-ece, py-vapid, requests }:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e80ae0ea978b2e3b7860d2a9ae836528f5fa2e13936673e0b6613589965937ee";
  };

  propagatedBuildInputs = [
    http-ece py-vapid requests
  ];

  checkInputs = [
    coverage flake8 mock nose
  ];

  meta = with lib; {
    description = "Webpush Data encryption library for Python";
    homepage = https://github.com/web-push-libs/pywebpush;
    license = licenses.mpl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
