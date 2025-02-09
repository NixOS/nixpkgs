{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, wcwidth
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ftfy";
  version = "6.1.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v8IBn4T82FFBkVIyCmN1YEoPFFnCgbWxmbLNDS5yf48=";
  };

  propagatedBuildInputs = [
    wcwidth
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTestPaths = [
    # Calls poetry and fails to match output exactly
    "tests/test_cli.py"
  ];


  meta = with lib; {
    description = "Given Unicode text, make its representation consistent and possibly less broken";
    homepage = "https://github.com/LuminosoInsight/python-ftfy";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
