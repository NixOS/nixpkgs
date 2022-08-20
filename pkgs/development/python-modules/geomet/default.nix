{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, six
}:

buildPythonPackage rec {
  pname = "geomet";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "geomet";
    repo = "geomet";
    rev = "refs/tags/${version}";
    hash = "sha256-7QfvGQlg4nTr1rwTyvTNm6n/jFptLtpBKMjjQj6OXCQ=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ turion ris ];
  };
}
