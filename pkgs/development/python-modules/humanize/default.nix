{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, gettext
, importlib-metadata
, pytestCheckHook
, pythonOlder
, hatch-vcs
, hatchling
}:

buildPythonPackage rec {
  pname = "humanize";
  version = "4.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sI773uzh+yMiyu1ebsk6zutfyt+tfx/zT/X2AdH5Fyg=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    gettext
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
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
