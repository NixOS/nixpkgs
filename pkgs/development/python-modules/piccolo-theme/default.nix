{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "piccolo-theme";
  version = "0.24.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit (finalAttrs) version;
    hash = "sha256-Cc9w9Lttuk680UlmVQwpIznBHZMclTMiHNPb/+sdG9k=";
  };

  dependencies = [ sphinx ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "piccolo_theme" ];

  meta = {
    description = "Clean and modern Sphinx theme";
    homepage = "https://piccolo-theme.readthedocs.io";
    changelog = "https://github.com/piccolo-orm/piccolo_theme/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ loicreynier ];
  };
})
