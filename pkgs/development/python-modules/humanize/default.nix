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
  version = "4.2.3";
  pname = "humanize";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = pname;
    rev = version;
    hash = "sha256-cAlNtN9sUnDAkCQj2bJfT72B2TQDYRBB4P4NJY9mUU0=";
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

  checkInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "humanize"
  ];

  meta = with lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/python-humanize/humanize";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo Luflosi ];
  };
}
