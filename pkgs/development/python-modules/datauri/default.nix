{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "datauri";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fcurella";
    repo = "python-datauri";
    rev = "v${version}";
    sha256 = "sha256-Eevd/xxKgxvvsAfI/L/KShH+PfxffBGyVwKewLgyEu0=";
  };

  pythonImportsCheck = [
    "datauri"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # UnicodeDecodeError: 'utf-8' codec can't decode
    "tests/test_file_ebcdic.txt"
  ];

  meta = with lib; {
    description = "Data URI manipulation made easy.";
    homepage = "https://github.com/fcurella/python-datauri";
    license = licenses.unlicense;
    maintainers = with maintainers; [ yuu ];
  };
}
