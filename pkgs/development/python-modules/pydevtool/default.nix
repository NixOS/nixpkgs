{
  lib,
  fetchPypi,
  setuptools,
  buildPythonPackage,
  doit,
}:

buildPythonPackage rec {
  pname = "pydevtool";
  version = "0.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JeO6Tz0zzKwz7iuXdZlYSNSemzGLehRkd/tdUveG/Io=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ doit ];

  pythonImportsCheck = [ "pydevtool" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/pydoit/pydevtool";
    description = "CLI dev tools powered by pydoit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
=======
  meta = with lib; {
    homepage = "https://github.com/pydoit/pydevtool";
    description = "CLI dev tools powered by pydoit";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
