{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "linknlink";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "xuanxuan000";
    repo = "python-linknlink";
    rev = "refs/tags/${version}";
    hash = "sha256-pr0FwNweg7hFcvaOHQyXjIzH1L6Q4q/1llwfdl9k0Sk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  pythonImportsCheck = [
    "linknlink"
  ];

  # Module has no test
  doCheck = false;

  meta = with lib; {
    description = "Module and CLI for controlling Linklink devices locally";
    homepage = "https://github.com/xuanxuan000/python-linknlink";
    changelog = "";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
