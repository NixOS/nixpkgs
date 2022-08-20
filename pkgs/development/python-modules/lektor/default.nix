{ lib
, babel
, buildPythonPackage
, click
, exifread
, fetchFromGitHub
, filetype
, flask
, inifile
, jinja2
, marshmallow
, marshmallow-dataclass
, mistune
, pip
, pyopenssl
, pytest-click
, pytest-mock
, pytest-pylint
, pytestCheckHook
, pythonOlder
, python-slugify
, requests
, setuptools
, watchdog
, werkzeug
, deprecated
}:

buildPythonPackage rec {
  pname = "lektor";
  version = "3.4.0b1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-uVLvxHlHqOMiRSoBi1wWxrN8tb78MO/QidHCE1uOXvc=";
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
    marshmallow
    marshmallow-dataclass
    mistune
    pip
    pyopenssl
    python-slugify
    requests
    setuptools
    watchdog
    werkzeug
  ];

  checkInputs = [
    pytest-click
    pytest-mock
    pytestCheckHook
  ];

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
    license = licenses.bsd0;
    maintainers = with maintainers; [ costrouc ];
  };
}
