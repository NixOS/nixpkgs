{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "23.9.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WB6k6Z8OMIhkQH4EwDxgkkGu+joV37qJZNp2RLrzshc=";
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
    homepage = "https://github.com/mk-fg/pretty-yaml";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
  };
}
