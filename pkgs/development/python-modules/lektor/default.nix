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
, typing-inspect
, watchdog
, werkzeug
}:

buildPythonPackage rec {
  pname = "lektor";
  version = "3.4.0b2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5w3tT0celHgjmLlsM3sdBdYlXx57z3kMePVGSQkOP7M=";
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

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "typing.inspect < 0.8.0" "typing.inspect"
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
    license = licenses.bsd0;
    maintainers = with maintainers; [ costrouc ];
  };
}
