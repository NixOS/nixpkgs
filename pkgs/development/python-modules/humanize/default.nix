{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, gettext
, pytestCheckHook
, pythonOlder
, hatch-vcs
, hatchling
}:

buildPythonPackage rec {
  pname = "humanize";
  version = "4.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sLlgR6c65RmUNZdH2pHuxzo7dm71uUZXGqzcqyxCrk4=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    gettext
  ];

  postBuild = ''
    scripts/generate-translation-binaries.sh
  '';

  postInstall = ''
    cp -r 'src/humanize/locale' "$out/lib/"*'/site-packages/humanize/'
  '';

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "humanize"
  ];

  meta = with lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/python-humanize/humanize";
    changelog = "https://github.com/python-humanize/humanize/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo Luflosi ];
  };
}
