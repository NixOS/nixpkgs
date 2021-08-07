{ lib
, fetchPypi
, buildPythonPackage
, cryptography
, http-ece
, py-vapid
, requests
, six
, coverage
, flake8
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97ef000a685cd1f63d9d3553568508508904bfe419485df2b83b025d94e9ae54";
  };

  propagatedBuildInputs = [
    cryptography
    http-ece
    py-vapid
    requests
    six
  ];

  checkInputs = [
    coverage
    flake8
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Webpush Data encryption library for Python";
    homepage = "https://github.com/web-push-libs/pywebpush";
    license = licenses.mpl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
