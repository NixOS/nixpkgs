{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, gettext
, importlib-metadata
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "humanize";
  version = "4.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vTfK45sZ9m7TUQJwZpQWhOXgZzO46CwCsnNP+PI1YfA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
    gettext
  ];

  propagatedBuildInputs = [
    setuptools
  ] ++ lib.optionals (pythonOlder "3.8") [
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
