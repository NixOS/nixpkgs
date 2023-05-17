{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, tempora
, six
}:

buildPythonPackage rec {
  pname = "jaraco-logging";
  version = "3.1.2";
  format = "pyproject";

  src = fetchPypi {
    pname = "jaraco.logging";
    inherit version;
    hash = "sha256-k6cLizdnd5rWx7Vu6YV5ztd7afFqu8rnSfYsLFnmeTE=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    tempora
    six
  ];

  # test no longer packaged with pypi
  doCheck = false;

  pythonImportsCheck = [ "jaraco.logging" ];

  meta = with lib; {
    description = "Support for Python logging facility";
    homepage = "https://github.com/jaraco/jaraco.logging";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
