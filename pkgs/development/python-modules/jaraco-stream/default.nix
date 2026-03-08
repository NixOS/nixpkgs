{
  lib,
  buildPythonPackage,
  fetchPypi,
  more-itertools,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jaraco-stream";
  version = "3.0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "jaraco_stream";
    inherit version;
    sha256 = "sha256-4rxQKOch7SzIUrluyaM/K3Zk6bLb+H7vvmF9EmZBk0s=";
  };

  build-system = [ setuptools-scm ];

  propagatedBuildInputs = [ more-itertools ];

  pythonNamespaces = [ "jaraco" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jaraco.stream" ];

  meta = {
    description = "Module with routines for handling streaming data";
    homepage = "https://github.com/jaraco/jaraco.stream";
    changelog = "https://github.com/jaraco/jaraco.stream/blob/v${version}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
