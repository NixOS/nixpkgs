{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "23.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zm9kjv37GzpVefjO2wT6zw+h6PZIRrY5MJtYW7MitOU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyyaml
  ];

  nativeCheckInputs = [
    unidecode
  ];

  pythonImportsCheck = [ "pyaml" ];

  meta = with lib; {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    mainProgram = "pyaml";
    homepage = "https://github.com/mk-fg/pretty-yaml";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
  };
}
