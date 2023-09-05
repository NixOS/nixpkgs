{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "23.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TiAw9fwNO1eEo6eFO6eLGujelDxtulUHh2VQxb0Y84c=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  nativeCheckInputs = [
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
