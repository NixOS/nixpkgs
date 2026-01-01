{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  pytest,
}:

buildPythonPackage rec {
  pname = "flask-script";
  version = "2.0.6";
  format = "setuptools";

  src = fetchPypi {
    pname = "Flask-Script";
    inherit version;
    hash = "sha256-ZCWWPZEFTPzBhYBxQccxSpxa1GMlkRvSTctIm9AWHGU=";
  };

  propagatedBuildInputs = [ flask ];
  nativeCheckInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/smurfix/flask-script";
    description = "Scripting support for Flask";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    homepage = "https://github.com/smurfix/flask-script";
    description = "Scripting support for Flask";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
