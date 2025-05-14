{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pythonOlder,

  unittestCheckHook,

  setuptools,
}:

buildPythonPackage rec {
  pname = "khanaa";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cakimpei";
    repo = "khanaa";
    tag = "v${version}";
    hash = "sha256-QFvvahVEld3BooINeUYJDahZyfh5xmQNtWRLAOdr6lw=";
  };

  build-system = [ setuptools ];

  patches = [
    ./001-skip-broken-test.patch
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "khanaa" ];

  meta = with lib; {
    description = "Tool to make spelling Thai more convenient";
    homepage = "https://github.com/cakimpei/khanaa";
    changelog = "https://github.com/cakimpei/khanaa/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
