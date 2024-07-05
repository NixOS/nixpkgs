{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  atpublic,
  zope-interface,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flufl-bounce";
  version = "4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "flufl.bounce";
    inherit version;
    hash = "sha256-JVBK65duwP5aGc1sQTo0EMtRT9zb3Kn5tdjTQ6hgODE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    atpublic
    zope-interface
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flufl.bounce" ];

  pythonNamespaces = [ "flufl" ];

  meta = with lib; {
    description = "Email bounce detectors";
    homepage = "https://gitlab.com/warsaw/flufl.bounce";
    changelog = "https://gitlab.com/warsaw/flufl.bounce/-/blob/${version}/flufl/bounce/NEWS.rst";
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}
