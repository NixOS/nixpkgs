{ lib
, babel
, buildPythonPackage
, click
, exifread
, fetchFromGitHub
, fetchNpmDeps
, filetype
, flask
, hatch-vcs
, hatchling
, importlib-metadata
, inifile
, jinja2
, markupsafe
, marshmallow
, marshmallow-dataclass
, mistune
, nodejs
, npmHooks
, pillow
, pip
, pytest-click
, pytest-mock
, pytest-pylint
, pytestCheckHook
, python
, pythonOlder
, python-slugify
, pytz
, requests
, watchfiles
, werkzeug
}:

buildPythonPackage rec {
  pname = "lektor";
  version = "3.4.0b8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FtmRW4AS11zAX2jvGY8XTsPrN3mhHkIWoFY7sXmqG/U=";
  };

  npmDeps = fetchNpmDeps {
    src = "${src}/frontend";
    hash = "sha256-Z7LP9rrVSzKoLITUarsnRbrhIw7W7TZSZUgV/OT+m0M=";
  };

  npmRoot = "frontend";

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    nodejs
    npmHooks.npmConfigHook
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    babel
    click
    exifread
    filetype
    flask
    inifile
    jinja2
    markupsafe
    marshmallow
    marshmallow-dataclass
    mistune
    pillow
    pip
    python-slugify
    requests
    watchfiles
    werkzeug
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.9") [
    pytz
  ];

  nativeCheckInputs = [
    pytest-click
    pytest-mock
    pytestCheckHook
  ];

  postInstall = ''
    cp -r lektor/translations "$out/${python.sitePackages}/lektor/"
  '';

  pythonImportsCheck = [
    "lektor"
  ];

  disabledTests = [
    # Tests require network access
    "test_path_installed_plugin_is_none"
    "test_VirtualEnv_run_pip_install"
    # expects FHS paths
    "test_VirtualEnv_executable"
  ];

  meta = with lib; {
    description = "A static content management system";
    homepage = "https://www.getlektor.com/";
    changelog = "https://github.com/lektor/lektor/blob/v${version}/CHANGES.md";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
