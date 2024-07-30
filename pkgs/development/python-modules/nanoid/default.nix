{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nanoid";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WoDK1enG6a46Qfovs0rhiffLQgsqXY+CvZ0jRm5O+mg=";
  };

  doCheck = false; # tests not in sdist, git not tagged

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nanoid" ];

  meta = with lib; {
    description = "Tiny, secure, URL-friendly, unique string ID generator for Python";
    homepage = "https://github.com/puyuan/py-nanoid";
    license = licenses.mit;
    maintainers = [ ];
  };
}
