{ lib
, boolean-py
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "license-expression";
<<<<<<< HEAD
  version = "30.1.1";
=======
  version = "30.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "license-expression";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-5pRfFRQLxWmhEKoJZiC7gZbmW8BbqBNBWbdwFL0MtpM=";
=======
    hash = "sha256-QPjVSSndgKlAdGY6nZjjOrnyyVfOVu8ggfBwGWi+RyE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    boolean-py
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "license_expression"
  ];

  meta = with lib; {
    description = "Utility library to parse, normalize and compare License expressions";
    homepage = "https://github.com/nexB/license-expression";
    changelog = "https://github.com/nexB/license-expression/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
