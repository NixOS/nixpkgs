{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "21.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oWNtY8R2MooHIT0LcRG7Y1cPGrij7d9gUiYwJQwj2XU=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  checkInputs = [
    unidecode
  ];

  pythonImportsCheck = [ "pyaml" ];

  meta = with lib; {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    homepage = "https://github.com/mk-fg/pretty-yaml";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
  };
}
