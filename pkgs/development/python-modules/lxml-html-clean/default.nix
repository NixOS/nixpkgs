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

  # the following tests are failing and should be enabled once the issue is solved
  # the bug is reported: https://github.com/fedora-python/lxml_html_clean/issues/24
  disabledTests = [
    "test_host_whitelist_valid"
    "test_clean_embed.txt"
    "test_clean.txt"
    "test_autolink.txt"
    "test_host_whitelist_invalid"
    "test_host_whitelist_sneaky_userinfo"
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
