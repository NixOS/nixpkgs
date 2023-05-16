<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, flask
, marshmallow
, packaging
, pytestCheckHook
, flask-sqlalchemy
, marshmallow-sqlalchemy
=======
{ lib, buildPythonPackage, fetchPypi,
  flask, six, marshmallow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
<<<<<<< HEAD
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "flask-marshmallow";
    rev = "refs/tags/${version}";
    hash = "sha256-N21M/MzcvOaDh5BgbbZtNcpRAULtWGLTMberCfOUoEM=";
  };

  propagatedBuildInputs = [
    flask
    marshmallow
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.sqlalchemy;

  pythonImportsCheck = [
    "flask_marshmallow"
  ];

  passthru.optional-dependencies = {
    sqlalchemy = [
      flask-sqlalchemy
      marshmallow-sqlalchemy
    ];
  };

  meta = {
    description = "Flask + marshmallow for beautiful APIs";
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    changelog = "https://github.com/marshmallow-code/flask-marshmallow/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
=======
  version = "0.14.0";

  meta = {
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    description = "Flask + marshmallow for beautiful APIs";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd01a6372cbe50e36f205cfff0fc5dab0b7b662c4c8b2c4fc06a3151b2950950";
  };

  propagatedBuildInputs = [ flask marshmallow ];
  buildInputs = [ six ];

  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
