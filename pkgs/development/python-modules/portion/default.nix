{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  wheel,
  sortedcontainers,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "portion";
  version = "2.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AlexandreDecan";
    repo = "portion";
    rev = "refs/tags/${version}";
    hash = "sha256-URoyuE0yivUqPjJZbvATkAnTxicY4F2eiJ16rIUdY3Y=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ sortedcontainers ];

  pythonImportsCheck = [ "portion" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Portion, a Python library providing data structure and operations for intervals";
    homepage = "https://github.com/AlexandreDecan/portion";
    changelog = "https://github.com/AlexandreDecan/portion/blob/${src.rev}/CHANGELOG.md";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
