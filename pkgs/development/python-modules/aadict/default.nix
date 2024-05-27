{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pynose,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aadict";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p3MorFXbtXNdqZRBhwJRvv4TX2h6twenoXhWE2OydwQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pynose ];

  pythonImportsCheck = [ "aadict" ];

  meta = with lib; {
    description = "An auto-attribute dict (and a couple of other useful dict functions)";
    homepage = "https://github.com/metagriffin/aadict";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ glittershark ];
  };
}
