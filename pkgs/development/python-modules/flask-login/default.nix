{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  flit-core,

  # dependencies
  flask,
  werkzeug,

  # tests
  asgiref,
  blinker,
  pytestCheckHook,
  semantic-version,
}:

buildPythonPackage rec {
  pname = "flask-login";
  version = "0.7.0dev0-2024-06-18";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-login";
    rev = "30675c56b651389d47b47eeb1ad114decb35b8fc";
    hash = "sha256-mIEYZnYWerjCetQuV2HRcmerMh2uLWNvHV7tfo5j4PU=";
  };

  build-system = [ flit-core ];

  dependencies = [
    flask
    werkzeug
  ];

  pythonImportsCheck = [ "flask_login" ];

  nativeCheckInputs = [
    asgiref
    blinker
    pytestCheckHook
    semantic-version
  ];

  meta = with lib; {
    changelog = "https://github.com/maxcountryman/flask-login/blob/${version}/CHANGES.md";
    description = "User session management for Flask";
    homepage = "https://github.com/maxcountryman/flask-login";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
