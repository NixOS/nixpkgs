{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "lxml-html-clean";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fedora-python";
    repo = "lxml_html_clean";
    tag = version;
    hash = "sha256-KGUFRbcaeDcX2jyoyyZMZsVTbN+h8uy+ugcritkZe38=";
  };

  # Disable failing snapshot tests (AssertionError)
  # https://github.com/fedora-python/lxml_html_clean/issues/24
  # As this derivation must use unittestCheckHook, we cannot use disabledTests
  postPatch = ''
    substituteInPlace tests/test_clean.py \
      --replace-fail \
        "test_host_whitelist_valid" \
        "DISABLED_test_host_whitelist_valid" \
      --replace-fail \
        "test_host_whitelist_invalid" \
        "DISABLED_test_host_whitelist_invalid" \
      --replace-fail \
        "test_host_whitelist_sneaky_userinfo" \
        "DISABLED_test_host_whitelist_sneaky_userinfo"
  '';

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "lxml_html_clean" ];

  meta = {
    description = "Separate project for HTML cleaning functionalities copied from lxml.html.clean";
    homepage = "https://github.com/fedora-python/lxml_html_clean/";
    changelog = "https://github.com/fedora-python/lxml_html_clean/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
