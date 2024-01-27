{ lib
, fetchPypi
, setuptools
, buildPythonPackage
, doit
}:

buildPythonPackage rec {
  pname = "pydevtool";
  version = "0.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JeO6Tz0zzKwz7iuXdZlYSNSemzGLehRkd/tdUveG/Io=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    doit
  ];

  pythonImportsCheck = [
    "pydevtool"
  ];

  meta = with lib; {
    homepage = "https://github.com/pydoit/pydevtool";
    description = "CLI dev tools powered by pydoit";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };

}
