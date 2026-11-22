{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  filelock,
  munch,
  requests,
  requests-toolbelt,
  requests-gssapi,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "copr";
  version = "2.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YLb6S9WGE2BPD6Dhk5aCRuEgpqen0Ii54UgQgahDz0Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    munch
    requests
    requests-toolbelt
    setuptools
  ];

  optional-dependencies = {
    gssapi = [ requests-gssapi ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "copr" ];

  meta = {
    description = "Python client for the Copr build service";
    homepage = "https://github.com/fedora-copr/copr";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
