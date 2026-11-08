{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core_3,

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
  version = "0.6.3-unstable-2025-08-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-login";
    rev = "c8bba84b9ba6768e878317fc46c54bd13fa1ac07";
    hash = "sha256-kXpNJ1GKrymHF//0q0NMJZ3DdJ0MFKft3dOAyn9QD2A=";
  };

  build-system = [ flit-core_3 ];

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

  meta = {
    changelog = "https://github.com/maxcountryman/flask-login/blob/${src.rev}/CHANGES.md";
    description = "User session management for Flask";
    homepage = "https://github.com/maxcountryman/flask-login";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
