{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  unittestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lxml-html-clean";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fedora-python";
    repo = "lxml_html_clean";
    rev = "refs/tags/${version}";
    hash = "sha256-vnRsSkhjeDxZ2bYbIe+2D4GjymZWcIVo2LAPuCaYIZo=";
  };

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "lxml_html_clean" ];

  meta = with lib; {
    description = "Separate project for HTML cleaning functionalities copied from lxml.html.clean";
    homepage = "https://github.com/fedora-python/lxml_html_clean/";
    changelog = "https://github.com/fedora-python/lxml_html_clean/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
