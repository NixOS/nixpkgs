{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-talisman";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xfSG9fVEIHKfhLPDhQzWP5bosDOpYpvuZsUk6jY3l/8=";
  };

  buildInputs = [ flask ];

  propagatedBuildInputs = [ six ];

  nativeBuildInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "HTTP security headers for Flask";
    homepage = "https://github.com/wntrblm/flask-talisman";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "HTTP security headers for Flask";
    homepage = "https://github.com/wntrblm/flask-talisman";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ lib.maintainers.symphorien ];
  };
}
