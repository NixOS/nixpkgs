{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  flask,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-themes2";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "Flask-Themes2";
    inherit version;
    hash = "sha256-gsMgQQXjhDfQRhm7H0kBy8jKxd75WY+PhHR6Rk/PUPs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ flask ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Easily theme your Flask app";
    homepage = "https://github.com/sysr-q/flask-themes2";
    license = licenses.mit;
    maintainers = with maintainers; [ ruby0b ];
  };
}
