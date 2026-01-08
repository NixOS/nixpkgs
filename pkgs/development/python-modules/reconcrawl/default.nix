{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  requests,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "reconcrawl";
  version = "0.1.0-unstable-2025-07-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reconurge";
    repo = "reconcrawl";
    # https://github.com/reconurge/reconcrawl/issues/1
    rev = "7333d1de13711be28eb01aed58e34a89c58f489b";
    hash = "sha256-NFCA9fEFnhg+2Edv6AM3e6uWBWBhqrjdroLKu0/g+zg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    lxml
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "reconcrawl" ];

  meta = {
    description = "Module to crawl out emails and phone numbers";
    homepage = "https://github.com/reconurge/reconcrawl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
