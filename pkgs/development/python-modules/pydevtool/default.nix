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
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JeO6Tz0zzKwz7iuXdZlYSNSemzGLehRkd/tdUveG/Io=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ doit ];

  pythonImportsCheck = [ "pydevtool" ];

  meta = {
    homepage = "https://github.com/pydoit/pydevtool";
    description = "CLI dev tools powered by pydoit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
