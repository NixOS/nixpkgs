{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "0.2.12";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BdTsx4UIRRK9fbMXOrgut651YMTowxHDFfitlP7ue2I=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "patiencediff"
  ];

  meta = with lib; {
    description = "C implementation of patiencediff algorithm for Python";
    homepage = "https://github.com/breezy-team/patiencediff";
    changelog = "https://github.com/breezy-team/patiencediff/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wildsebastian ];
  };
}
