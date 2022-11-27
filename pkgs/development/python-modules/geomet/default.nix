{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "geomet";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "geomet";
    repo = "geomet";
    rev = "refs/tags/${version}";
    hash = "sha256-dN0d6wu5FqL/5FQrpQn+wlyEvp52pa5dkxLu3j3bxnw=";
  };

  propagatedBuildInputs = [
    click
    six
  ];

  pythonImportsCheck = [
    "geomet"
  ];

  meta = with lib; {
    description = "Convert GeoJSON to WKT/WKB (Well-Known Text/Binary) and vice versa";
    homepage = "https://github.com/geomet/geomet";
    changelog = "https://github.com/geomet/geomet/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ turion ris ];
  };
}
