{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit,
  markdown-it-py,
  mdformat,
  mdit-py-plugins,
  pipx,
  pythonOlder,
  tox,
}:

buildPythonPackage rec {
  pname = "mdformat-gfm-alerts";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8.5";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2EYdNCyS1LxcEnCXkOugAAGx5XLWV4cWTNkXjR8RVQo=";
  };

  nativeBuildInputs = [
    flit
    pipx
  ];

  propagatedBuildInputs = [
    markdown-it-py
    mdformat
    mdit-py-plugins
  ];

  nativeCheckInputs = [ tox ];

  pythonImportsCheck = [ "mdformat_gfm_alerts" ];

  meta = with lib; {
    description = "Mdformat plugin for Alerts in GitHub Flavored Markdown";
    homepage = "https://github.com/KyleKing/${pname}";
    license = licenses.mit;
    maintainers = with maintainers; [ sudoforge ];
  };
}
