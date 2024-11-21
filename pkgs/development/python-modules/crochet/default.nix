{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  versioneer,
  configparser,
  twisted,
  wrapt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "crochet";
  version = "2.1.1";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fs5p3hzo5j/8CvjiMx7E64mNke1Ccar6TMw5hSO4HPk=";
  };

  # Remove vendored versioneer
  postPatch = ''
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    twisted
    wrapt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = pname;

  meta = with lib; {
    description = "Library that makes it easier to use Twisted from regular blocking code";
    homepage = "https://github.com/itamarst/crochet";
    changelog = "https://github.com/itamarst/crochet/blob/${version}/docs/news.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
