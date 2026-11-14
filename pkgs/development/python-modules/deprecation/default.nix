{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  packaging,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "deprecation";
  version = "2.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-crO95k5dd4aUsM9oF4rtA9FeFUdxFq3T+3c+WB+VGP8=";
  };

  patches = [
    # fixes for python 3.10 test suite
    (fetchpatch {
      url = "https://github.com/briancurtin/deprecation/pull/57/commits/e13e23068cb8d653a02a434a159e8b0b7226ffd6.patch";
      hash = "sha256-/5zr2V1s5ULUZnbLXsgyHxZH4m7/a27QYuqQt2Savc8=";
      includes = [ "tests/test_deprecation.py" ];
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "deprecation" ];

  meta = {
    description = "Library to handle automated deprecations";
    homepage = "https://deprecation.readthedocs.io/";
    license = lib.licenses.asl20;
  };
})
