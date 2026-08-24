{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  chardet,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "binaryornot";
  version = "0.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-zI1Xz6cddP+MKKdyZzTVOoUdAvrZ46VYH7gH+Yn3AvA=";
  };

  build-system = [ setuptools ];

  prePatch = ''
    # TypeError: binary() got an unexpected keyword argument 'average_size'
    substituteInPlace tests/test_check.py \
      --replace-fail "average_size=512" ""
  '';

  dependencies = [ chardet ];

  nativeCheckInputs = [ hypothesis ];

  pythonImportsCheck = [ "binaryornot" ];

  meta = {
    homepage = "https://github.com/audreyr/binaryornot";
    description = "Ultra-lightweight pure Python package to check if a file is binary or text";
    license = lib.licenses.bsd3;
  };
})
