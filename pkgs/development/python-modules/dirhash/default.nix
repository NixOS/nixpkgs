{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  scantree,
  setuptools,
  versioneer,
}:

buildPythonPackage (finalAttrs: {
  pname = "dirhash";
  version = "0.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "andhus";
    repo = "dirhash-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lTg9GwHArwHnZC7UwQEGa9TVdLKbkVANV84hkKsqQUo=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [ scantree ];

  # The CLI is installed in $out/bin rather than next to the Python interpreter.
  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace-fail 'os.path.dirname(sys.executable),' "\"$out/bin\","
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dirhash" ];

  meta = {
    description = "Python module and CLI for hashing file system directories";
    homepage = "https://github.com/andhus/dirhash-python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.hobr ];
    mainProgram = "dirhash";
  };
})
