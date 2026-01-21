{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  importlib-metadata,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mockfs";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mockfs";
    repo = "mockfs";
    rev = "v${version}";
    hash = "sha256-JwSkOI0dz9ZetfE0ZL3CthvcCSXGFYX+yQZy/oC6VBk=";
  };

  postPatch = ''
    sed -i '/addopts/d' pytest.ini
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ importlib-metadata ];

  pythonImportsCheck = [ "mockfs" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Simple mock filesystem for use in unit tests";
    homepage = "https://github.com/mockfs/mockfs";
    changelog = "https://github.com/mockfs/mockfs/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
