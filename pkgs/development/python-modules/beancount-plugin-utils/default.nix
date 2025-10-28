{
  lib,
  beancount,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-bdd,
  pytestCheckHook,
  regex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "beancount-plugin-utils";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Akuukis";
    repo = "beancount_plugin_utils";
    rev = "v${version}";
    hash = "sha256-oyfL2K/sS4zZ7cq1P36h0dTcW1m5GUyQ9+IyZGfpb2E=";
  };

  build-system = [ setuptools ];

  dependencies = [ beancount ];

  nativeCheckInputs = [
    pytest-bdd
    pytestCheckHook
    regex
  ];

  pytestFlags = [ "--fixtures" ];

  enabledTestPaths = [
    "tests/"
  ];

  pythonImportsCheck = [ "beancount" ];

  meta = with lib; {
    homepage = "https://github.com/Akuukis/beancount_plugin_utils";
    description = "Utils for beancount plugin writers - BeancountError, mark, metaset, etc";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ alapshin ];
  };
}
