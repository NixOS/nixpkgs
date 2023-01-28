{ lib
, buildPythonPackage
, diskcache
, eventlet
, fetchFromGitHub
, more-itertools
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.18";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "harlowja";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FGcGGRfObOqXuURyEuNt/KDn51POpdNPUJJKtMcLJNI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    diskcache
    eventlet
    more-itertools
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fasteners"
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  meta = with lib; {
    description = "Module that provides useful locks";
    homepage = "https://github.com/harlowja/fasteners";
    changelog = "https://github.com/harlowja/fasteners/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
