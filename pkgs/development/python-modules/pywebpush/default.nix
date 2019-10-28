{ lib, fetchPypi, buildPythonPackage
, coverage, flake8, mock, nose
, http-ece, py-vapid, requests }:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de8b7e638c6b595c6405f16fd5356e92d2feb8237ab4e50a89770e4ed93aebd6";
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
