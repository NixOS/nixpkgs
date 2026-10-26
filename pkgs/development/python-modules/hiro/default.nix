{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  mock,
}:
buildPythonPackage (finalAttrs: {
  pname = "hiro";
  version = "1.1.1";
  format = "setuptools";
  src = fetchPypi {
    inherit (finalAttrs) pname version;

    hash = "sha256-2jM5rx3JpZTMqdycccclJysuMGYE5F0OBXXNE8X5XWg=";
  };

  propagatedBuildInputs = [
    six
    mock
  ];

  meta = {
    description = "Time manipulation utilities for Python";
    homepage = "https://hiro.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyarly ];
  };
})
