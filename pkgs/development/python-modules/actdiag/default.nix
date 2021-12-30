{ lib
, blockdiag
, buildPythonPackage
, fetchFromGitHub
, nose
, pytestCheckHook
, pythonOlder
, setuptools
, actdiag
, testVersion
}:

buildPythonPackage rec {
  pname = "actdiag";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = pname;
    rev = version;
    sha256 = "sha256-pTWunoc6T1m+4SOe0ob0ac4ZwwXsYNZwkdwVtlMZrIo=";
  };

  propagatedBuildInputs = [
    blockdiag
    setuptools
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/actdiag/tests/"
  ];

  pythonImportsCheck = [
    "actdiag"
  ];

  passthru.tests.version = testVersion { package = actdiag; };

  meta = with lib; {
    description = "Generate activity-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor SuperSandro2000 ];
  };
}
