{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      # Replace deprecated failIf with assertFalse for Python 3.12 compatibility.
      url = "https://gitlab.com/warsaw/flufl.bounce/-/commit/e0b9fd0f24572e024a8d0484a3c9fb4542337d18.patch";
      hash = "sha256-HJHEbRVjiiP5Z7W0sQCj6elUMyaWOTqQw6UpYOYCVZM=";
    })
  ];

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
    maintainers = [ ];
    license = licenses.asl20;
  };
}
