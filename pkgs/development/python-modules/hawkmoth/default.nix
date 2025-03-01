{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  hatchling,
  sphinx,
  libclang,
}:

buildPythonPackage rec {
  pname = "hawkmoth";
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NxjSUg/ZznuAKItzbc/sInZGbQxJLXy0HLyCLxLK8yo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    sphinx
    libclang
  ];

  pythonImportsCheck = [ "hawkmoth" ];

  meta = with lib; {
    description = "Sphinx Autodoc for C";
    homepage = "https://jnikula.github.io/hawkmoth/";
    changelog = "https://github.com/jnikula/hawkmoth/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cynerd ];
  };
}
