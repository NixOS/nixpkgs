{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f8kFJyzvpPNkwaNCnLvpwPmLeTmI77W/kKrIDwjbCbE=";
  };

  postPatch = ''
    # broken with pytest 7
    # https://github.com/wolever/parameterized/issues/167
    substituteInPlace parameterized/test.py \
      --replace 'assert_equal(missing, [])' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "parameterized/test.py"
  ];

  pythonImportsCheck = [
    "parameterized"
  ];

  meta = with lib; {
    description = "Parameterized testing with any Python test framework";
    homepage = "https://github.com/wolever/parameterized";
    changelog = "https://github.com/wolever/parameterized/blob/v${version}/CHANGELOG.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
