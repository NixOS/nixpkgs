{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  random2,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysol-cards";
  version = "0.24.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "pysol_cards";
    hash = "sha256-qYVJLagaoViN/AVtmnxsqD9mJUwLkPJa/GgqcHE9TUs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    random2
  ];

  meta = {
    description = "Generates Solitaire deals";
    mainProgram = "pysol_cards";
    homepage = "https://github.com/shlomif/pysol_cards";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mwolfe ];
  };
})
