{ lib
, buildPythonPackage
, fetchFromGitHub
, lzo
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "python-lzo";
  version = "1.16";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jd-boyd";
    repo = "python-lzo";
    rev = "refs/tags/v${version}";
    hash = "sha256-iXAvOCzHPvNERMkE5y4QTHi4ZieW1wrYWYScs7zyb2c=";
  };


  nativeBuildInputs = [
    setuptools
    wheel
  ];

  buildInputs = [
    lzo
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "lzo"
  ];

  meta = with lib; {
    description = "Python bindings for the LZO data compression library";
    homepage = "https://github.com/jd-boyd/python-lzo";
    changelog = "https://github.com/jd-boyd/python-lzo/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jbedo ];
  };
}
