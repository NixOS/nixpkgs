{ lib
, babel
, buildPythonPackage
, click
, deprecated
, exifread
, fetchFromGitHub
, filetype
, flask
, importlib-metadata
, inifile
, jinja2
, markupsafe
, marshmallow
, marshmallow-dataclass
, mistune
, pip
, pyopenssl
, pytest-click
, pytest-mock
, pytest-pylint
, pytestCheckHook
, python
, pythonOlder
, python-slugify
, pytz
, requests
, setuptools
, typing-inspect
, watchdog
, werkzeug
}:

buildPythonPackage rec {
  pname = "lektor";
  version = "3.4.0b4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-O0bTmJqRymrQuHW19Y7/Kp+2XlbmDzcjl/jDACDlCSk=";
  };

  propagatedBuildInputs = [
    babel
    click
    deprecated
    exifread
    filetype
    flask
    inifile
    jinja2
    markupsafe
    marshmallow
    marshmallow-dataclass
    mistune
    pip
    pyopenssl
    python-slugify
    pytz
    requests
    setuptools
    typing-inspect
    watchdog
    werkzeug
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
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
    # Test requires network access
    "test_path_installed_plugin_is_none"
  ];

  meta = with lib; {
    description = "A static content management system";
    homepage = "https://www.getlektor.com/";
    changelog = "https://github.com/lektor/lektor/blob/v${version}/CHANGES.md";
    license = licenses.bsd0;
    maintainers = with maintainers; [ costrouc ];
  };
}
