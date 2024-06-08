{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyyaml,
  unidecode,
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "24.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dkg9kokBDnR6Ml3EMXG8w51lYt0d1HGejMfnyWyZ/OY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ unidecode ];

  pythonImportsCheck = [ "pyaml" ];

  meta = with lib; {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    mainProgram = "pyaml";
    homepage = "https://github.com/mk-fg/pretty-yaml";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
  };
}
