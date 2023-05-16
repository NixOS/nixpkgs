<<<<<<< HEAD
{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flask
, markdown
}:

buildPythonPackage rec {
  pname = "Flask-API";
  version = "3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "flask-api";
    repo = "flask-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-nHgeI5FLKkDp4uWO+0eaT4YSOMkeQ0wE3ffyJF+WzTM=";
  };

  propagatedBuildInputs = [
    flask
    markdown
  ];

  meta = with lib; {
    homepage = "https://github.com/flask-api/flask-api";
    changelog = "https://github.com/flask-api/flask-api/releases/tag/v${version}";
    description = "Browsable web APIs for Flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nickcao ];
=======
{ lib, buildPythonPackage, pythonOlder, fetchPypi, flask, markdown }:

buildPythonPackage rec {
  pname = "Flask-API";
  version = "3.0.post1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1khw0f9ywn1mbdlcl0xspacqjz2pxq00m4g73bksbc1k0i88j61k";
  };

  propagatedBuildInputs = [ flask markdown ];

  meta = with lib; {
    homepage = "https://github.com/miracle2k/flask-assets";
    description = "Browsable web APIs for Flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
