{ lib
, buildPythonPackage
, cffi
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "2024.1.14";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ogjBcm4SujhRJc7yxtN1xBxd6kzCZzp3r3ErHb8HTpA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedNativeBuildInputs = [
    cffi
  ];

  propagatedBuildInputs = [
    cffi
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cmarkgfm"
  ];

  meta = with lib; {
    description = "Minimal bindings to GitHub's fork of cmark";
    homepage = "https://github.com/jonparrott/cmarkgfm";
    changelog = "https://github.com/theacodes/cmarkgfm/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
