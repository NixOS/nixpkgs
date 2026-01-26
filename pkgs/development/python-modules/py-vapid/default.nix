{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  mock,
  pytestCheckHook,
  cryptography,
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.9.2";
  pyproject = true;

  src = fetchPypi {
    pname = "py_vapid";
    inherit version;
    hash = "sha256-PIlzts+DhK0MmuZNYnDMxIDguSxwLY9eoswD5rUSR/k=";
  };

  patches = [
    # Fix tests with latest cryptography
    # Upstream PR: https://github.com/web-push-libs/vapid/pull/110
    ./cryptography.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  meta = {
    description = "Library for VAPID header generation";
    mainProgram = "vapid";
    homepage = "https://github.com/mozilla-services/vapid";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
