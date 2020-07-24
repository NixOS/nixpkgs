{ lib, fetchPypi, buildPythonPackage
, coverage, flake8, mock, nose
, http-ece, py-vapid, requests }:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "596c74020f9cbabc99f7964127ab0bb6cc045fcfe781b7c73cffb3ea45947820";
  };

  propagatedBuildInputs = [
    http-ece py-vapid requests
  ];

  checkInputs = [
    coverage flake8 mock nose
  ];

  meta = with lib; {
    description = "Webpush Data encryption library for Python";
    homepage = "https://github.com/web-push-libs/pywebpush";
    license = licenses.mpl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
