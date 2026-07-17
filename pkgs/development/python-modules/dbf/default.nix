{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  aenum,
  pytestCheckHook,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "dbf";
  version = "0.99.11";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "dbf";
    inherit (finalAttrs) version;
    hash = "sha256-IWnAUlLA776JfzRvBoMybsJYVL6rHQxkMN9ukDpXsxU=";
  };

  build-system = [ setuptools ];

  # Workaround for https://github.com/ethanfurman/dbf/issues/48
  patches = lib.optional python.stdenv.hostPlatform.isDarwin ./darwin.patch;

  dependencies = [ aenum ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    sed -i '/^import tempfile$/a tempdir = tempfile.mkdtemp()' dbf/test.py
  '';

  enabledTestPaths = [ "dbf/test.py" ];

  pythonImportsCheck = [ "dbf" ];

  meta = {
    description = "Module for reading/writing dBase, FoxPro, and Visual FoxPro .dbf files";
    homepage = "https://github.com/ethanfurman/dbf";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
