{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "backports-strenum";
  version = "1.2.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "clbarnes";
    repo = "backports.strenum";
    rev = "refs/tags/v${version}";
    hash = "sha256-AhAMVawnBMJ45a3mpthUZvqTeqeCB1Uco4MSusLyA4E=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "backports.strenum"
  ];

  meta = with lib; {
    description = "Base class for creating enumerated constants that are also subclasses of str";
    homepage = "https://github.com/clbarnes/backports.strenum";
    license = with licenses; [ psfl ];
    maintainers = with maintainers; [ fab ];
  };
}
