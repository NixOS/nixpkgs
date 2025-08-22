{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libsast";
  version = "3.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ajinabraham";
    repo = "libsast";
    tag = version;
    hash = "sha256-A02VcSgd58m7ZomvAz0TBEe8hRZhx29jAjYl48fwPKg=";
  };

  build-system = [ setuptools ];

  buildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "libsast" ];

  meta = {
    description = "Generic SAST Library";
    homepage = "https://github.com/ajinabraham/libsast";
    changelog = "https://github.com/ajinabraham/libsast/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
