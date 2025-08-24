{
  lib,
  attrs,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  bibtexparser_2,
  git,
  lxml,
  markdown,
  markupsafe,
  postgresql,
  pylatexenc,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  tabulate,
}:

buildPythonPackage rec {
  pname = "clldutils";
  version = "3.24.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clld";
    repo = "clldutils";
    tag = "v${version}";
    hash = "sha256-xIs6Lq9iDdcM3j51F27x408oUldvy5nlvVdbrAS5Jz0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    bibtexparser_2
    colorlog
    lxml
    markdown
    markupsafe
    pylatexenc
    python-dateutil
    tabulate
  ];

  nativeCheckInputs = [
    postgresql
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    git
  ];

  meta = {
    changelog = "https://github.com/clld/clldutils/blob/${src.tag}/CHANGES.md";
    description = "Utilities for clld apps without the overhead of requiring pyramid, rdflib et al";
    homepage = "https://github.com/clld/clldutils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ melling ];
  };
}
