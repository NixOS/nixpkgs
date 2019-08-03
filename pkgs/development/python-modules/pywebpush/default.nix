{ lib, fetchPypi, buildPythonPackage
, coverage, flake8, mock, nose
, http-ece, py-vapid, requests }:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "1.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03qkijz56fx7p8405sknw2wji4pfj5knajk2lmj9y58mjxydbpp3";
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
