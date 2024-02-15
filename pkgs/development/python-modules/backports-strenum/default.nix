{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "backports-strenum";
  version = "1.2.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "clbarnes";
    repo = "backports.strenum";
    rev = "refs/tags/v${version}";
    hash = "sha256-jbMR9VAGsMAJTP2VQyRr+RPYwWwk8hGAYs4KoZEWa7U=";
  };

  nativeBuildInputs = [
    poetry-core
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
