{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  setuptools-scm,
  tempora,
}:

buildPythonPackage rec {
  pname = "jaraco-logging";
  version = "3.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jaraco_logging";
    inherit version;
    hash = "sha256-59bcg2hHfOaesdbthR2AWJahypQs4/0Xc1gDEbC3dfs=";
  };

  postPatch = ''
    sed -i "/coherent\.licensed/d" pyproject.toml
  '';

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ tempora ];

  # test no longer packaged with pypi
  doCheck = false;

  pythonImportsCheck = [ "jaraco.logging" ];

  meta = with lib; {
    description = "Support for Python logging facility";
    homepage = "https://github.com/jaraco/jaraco.logging";
    changelog = "https://github.com/jaraco/jaraco.logging/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
