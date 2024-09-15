{
  lib,
  attrs,
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
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  tabulate,
}:

buildPythonPackage rec {
  pname = "clldutils";
  version = "3.21.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "clld";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OD+WJ9JuYZb/oXDgVqL4i5YlcVEt0+swq0SB3cutyRo=";
  };

  patchPhase = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    attrs
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
