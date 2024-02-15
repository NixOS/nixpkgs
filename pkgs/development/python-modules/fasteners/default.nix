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
  version = "0.19";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "harlowja";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-XFa1ItFqkSYE940p/imWFp5e9gS6n+D1uM6Cj+Vzmmg=";
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
