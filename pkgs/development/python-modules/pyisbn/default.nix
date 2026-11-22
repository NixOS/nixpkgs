{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  pytest-cov-stub,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyisbn";
  version = "1.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-qPOS8G/ZUqH23mvhSKcs93s8UfpXIxIc0cIgGvRjpbM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.0,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyisbn" ];

  meta = {
    description = "Python module for working with 10- and 13-digit ISBNs";
    homepage = "https://github.com/JNRowe/pyisbn";
    changelog = "https://github.com/JNRowe/pyisbn/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
