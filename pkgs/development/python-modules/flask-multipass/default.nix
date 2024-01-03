{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "flask-multipass";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "indico";
    repo = "flask-multipass";
    rev = "v${version}";
    hash = "sha256-MxJIprLqRLVLTZeslMccJFxVjXCJxb3iH6PRIMJSChI=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.flask
  ];

  pythonImportsCheck = [ "flask_multipass" ];

  meta = with lib; {
    description = "Multi-backend authentication system for Flask";
    homepage = "https://github.com/indico/flask-multipass";
    changelog = "https://github.com/indico/flask-multipass/blob/${src.rev}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "flask-multipass";
  };
}
