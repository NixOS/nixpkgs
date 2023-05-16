<<<<<<< HEAD
{ lib
, fetchFromGitHub
, buildPythonPackage
, flit-core
, flask
, cachelib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Flask-Session";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-session";
    rev = "refs/tags/${version}";
    hash = "sha256-t8w6ZS4gBDpnnKvL3DLtn+rRLQNJbrT2Hxm4f3+a3Xc=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    flask
    cachelib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # The rest of the tests require database servers and optional db connector dependencies
  pytestFlagsArray = [
    "-k"
    "'null_session or filesystem_session'"
  ];

  pythonImportsCheck = [
    "flask_session"
  ];

  meta = with lib; {
    description = "A Flask extension that adds support for server-side sessions";
    homepage = "https://github.com/pallets-eco/flask-session";
    changelog = "https://github.com/pallets-eco/flask-session/releases/tag/${version}";
=======
{ lib, fetchPypi, buildPythonPackage, pytestCheckHook, flask, cachelib }:

buildPythonPackage rec {
  pname = "Flask-Session";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ye1UMh+oxMoBMv/TNpWCdZ7aclL7SzvuSA5pDRukH0Y=";
  };

  propagatedBuildInputs = [ flask cachelib ];

  nativeCheckInputs = [ pytestCheckHook ];

  # The rest of the tests require database servers and optional db connector dependencies
  pytestFlagsArray = [ "-k" "'null_session or filesystem_session'" ];

  pythonImportsCheck = [ "flask_session" ];

  meta = with lib; {
    description = "A Flask extension that adds support for server-side sessions";
    homepage = "https://github.com/fengsp/flask-session";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
