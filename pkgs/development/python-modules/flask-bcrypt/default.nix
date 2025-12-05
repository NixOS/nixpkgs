{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  bcrypt,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-bcrypt";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-bcrypt";
    rev = version;
    hash = "sha256-WlIholi/nzq6Ikc0LS6FhG0Q5Kz0kvvAlA2YJ7EksZ4=";
  };

  postPatch = ''
    # Backport fix for test_long_password from upstream PR: https://github.com/maxcountryman/flask-bcrypt/pull/96
    substituteInPlace test_bcrypt.py \
      --replace-fail "self.assertTrue(self.bcrypt.check_password_hash(pw_hash, 'A' * 80))" \
                     "self.assertTrue(self.bcrypt.check_password_hash(pw_hash, 'A' * 72))"
  '';

  propagatedBuildInputs = [
    flask
    bcrypt
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "flask_bcrypt" ];

  meta = with lib; {
    description = "Brcrypt hashing for Flask";
    homepage = "https://github.com/maxcountryman/flask-bcrypt";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
