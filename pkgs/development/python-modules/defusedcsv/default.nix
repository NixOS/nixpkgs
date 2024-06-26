{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "defusedcsv";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "defusedcsv";
    rev = "refs/tags/v${version}";
    hash = "sha256-y8qLVfdkxRrDjtrTOLK5Zvi/1Vyv8eOnCueUkaRp4sQ=";
  };

  pythonImportsCheck = [ "defusedcsv.csv" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python library to protect your users from Excel injections in CSV-format exports, drop-in replacement for standard library's csv module";
    homepage = "https://github.com/raphaelm/defusedcsv";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
