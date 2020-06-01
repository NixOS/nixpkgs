{ lib, fetchPypi, buildPythonPackage
, coverage, flake8, mock, nose
, http-ece, py-vapid, requests }:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61e6b92ee23ea3f7afbb427508e51c789a0c10cbc962fab9de582ad48b5792e4";
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
