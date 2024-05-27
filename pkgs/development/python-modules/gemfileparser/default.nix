{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gemfileparser";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g5WS5J6j/Zhc7AA+9Y+OdwCaae12RKDArMlM9t2bjW4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gemfileparser" ];

  meta = with lib; {
    description = "A library to parse Ruby Gemfile, .gemspec and Cocoapod .podspec file using Python";
    homepage = "https://github.com/gemfileparser/gemfileparser";
    license = with licenses; [
      gpl3Plus
      mit
    ];
    maintainers = with maintainers; [ ];
    mainProgram = "parsegemfile";
  };
}
