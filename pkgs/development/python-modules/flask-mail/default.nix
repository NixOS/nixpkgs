{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  blinker,
  flit-core,
  flask,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-mail";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-mail";
    tag = version;
    hash = "sha256-G2Z8dj1/IuLsZoNJVrL6LYu0XjTEHtWB9Z058aqG9Ic=";
  };

  build-system = [ flit-core ];

  dependencies = [
    blinker
    flask
  ];

  pythonImportsCheck = [ "flask_mail" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Broken by fix for CVE-2023-27043.
    # Reported upstream in https://github.com/pallets-eco/flask-mail/issues/233
    "test_unicode_sender_tuple"
    "test_unicode_sender"
  ];

  meta = {
    description = "Flask extension providing simple email sending capabilities";
    homepage = "https://github.com/pallets-eco/flask-mail";
    changelog = "https://github.com/pallets-eco/flask-mail/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.bsd3;
  };
}
