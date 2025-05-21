{
  lib,
  attrs,
  bibtexparser,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  git,
  lxml,
  markdown,
  markupsafe,
  mock,
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
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "clld";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xIs6Lq9iDdcM3j51F27x408oUldvy5nlvVdbrAS5Jz0=";
  };

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    attrs
    bibtexparser
    colorlog
    lxml
    markdown
    markupsafe
    pylatexenc
    python-dateutil
    tabulate
  ];

  nativeCheckInputs = [
    mock
    postgresql
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    git
  ];

  meta = with lib; {
    changelog = "https://github.com/clld/clldutils/blob/${src.rev}/CHANGES.md";
    description = "Utilities for clld apps without the overhead of requiring pyramid, rdflib et al";
    homepage = "https://github.com/clld/clldutils";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
