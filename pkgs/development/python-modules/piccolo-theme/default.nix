{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  sphinx,
}:

buildPythonPackage rec {
  pname = "piccolo-theme";
  version = "0.24.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit version;
    hash = "sha256-Cc9w9Lttuk680UlmVQwpIznBHZMclTMiHNPb/+sdG9k=";
  };

  dependencies = [ sphinx ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "piccolo_theme" ];

  meta = with lib; {
    description = "Clean and modern Sphinx theme";
    homepage = "https://piccolo-theme.readthedocs.io";
    changelog = "https://github.com/piccolo-orm/piccolo_theme/releases/tag/${version}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ loicreynier ];
  };
}
