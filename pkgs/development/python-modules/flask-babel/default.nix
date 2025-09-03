{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  poetry-core,

  # docs
  furo,
  sphinxHook,

  # runtime
  babel,
  flask,
  jinja2,
  pytz,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-babel";
  version = "4.1.0";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "python-babel";
    repo = "flask-babel";
    tag = "v${version}";
    hash = "sha256-NcwcMLGabWrjbFZhDU1MVWpqAm0prBlqHfTdLV7EqoI=";
  };

  patches = [
    # Fix list-translations() ordering in tests
    # https://github.com/python-babel/flask-babel/pull/242
    (fetchpatch {
      url = "https://github.com/python-babel/flask-babel/pull/242/commits/999735d825ee2f94701da29bcf819ad70ee03499.patch";
      hash = "sha256-vhP/aSWaWpy1sVOJAcrLHJN/yrB+McWO9pkXDI9GeQ4=";
    })
  ];

  nativeBuildInputs = [
    furo
    sphinxHook
  ];

  build-system = [ poetry-core ];

  dependencies = [
    babel
    flask
    jinja2
    pytz
  ];

  pythonImportsCheck = [ "flask_babel" ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/python-babel/flask-babel/releases/tag/v${version}";
    description = "Adds i18n/l10n support to Flask applications";
    longDescription = ''
      Implements i18n and l10n support for Flask.
      This is based on the Python babel module as well as pytz both of which are
      installed automatically for you if you install this library.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ matejc ];
    teams = [ teams.sage ];
    homepage = "https://github.com/python-babel/flask-babel";
  };
}
