{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lxml-html-clean";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fedora-python";
    repo = "lxml_html_clean";
    tag = version;
    hash = "sha256-KGUFRbcaeDcX2jyoyyZMZsVTbN+h8uy+ugcritkZe38=";
  };

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # these tests fail with libxml >= 2.13
    # https://github.com/NixOS/nixpkgs/issues/418689
    # upstream: https://github.com/fedora-python/lxml_html_clean/issues/24
    "test_host_whitelist_invalid"
    "test_host_whitelist_sneaky_userinfo"
    "test_host_whitelist_valid"
  ];

  pythonImportsCheck = [ "lxml_html_clean" ];

  meta = with lib; {
    description = "Separate project for HTML cleaning functionalities copied from lxml.html.clean";
    homepage = "https://github.com/fedora-python/lxml_html_clean/";
    changelog = "https://github.com/fedora-python/lxml_html_clean/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
