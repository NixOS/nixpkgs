{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  click,
}:

let
  libName = "confusable-homoglyphs";
  snakeLibName = builtins.replaceStrings [ "-" ] [ "_" ] libName;
in
buildPythonPackage rec {
  pname = libName;
  version = "3.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = snakeLibName;
    hash = "sha256-uZUAHJsuG0zqDPXzhAp8eRiKjLutBT1pNXK9jBwexGA=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  optional-dependencies = {
    cli = [ click ];
  };

  pythonImportsCheck = [ snakeLibName ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.cli;

  disabledTests = [
    "test_generate_categories" # touches network
    "test_generate_confusables" # touches network
  ];

  meta =
    let
      inherit (lib) licenses maintainers;
    in
    {
      description = "Detect confusable usage of unicode homoglyphs, prevent homograph attacks";
      homepage = "https://sr.ht/~valhalla/confusable_homoglyphs/";
      changelog = "https://confusable-homoglyphs.readthedocs.io/en/latest/history.html";
      license = licenses.mit;
      maintainers = with maintainers; [ ajaxbits ];
    };
}
