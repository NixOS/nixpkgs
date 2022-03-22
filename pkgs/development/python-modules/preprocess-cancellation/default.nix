{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, poetry-core
, pytestCheckHook, pytest-cov
, shapely }:

buildPythonPackage rec {
  pname = "preprocess-cancellation";
  version = "0.2.0";
  disabled = pythonOlder "3.6"; # >= 3.6
  format = "pyproject";

  # No tests in PyPI
  src = fetchFromGitHub {
    owner = "kageurufu";
    repo = "cancelobject-preprocessor";
    rev = version;
    hash = "sha256-mn3/etXA5dkL+IsyxwD4/XjU/t4/roYFVyqQxlLOoOI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ shapely ];

  checkInputs = [ pytestCheckHook pytest-cov ];

  meta = with lib; {
    description = "Klipper GCode Preprocessor for Object Cancellation";
    homepage = "https://github.com/kageurufu/cancelobject-preprocessor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
