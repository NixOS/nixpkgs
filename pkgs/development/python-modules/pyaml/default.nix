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
  version = "25.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V5lWDHscna81p6RTX1PiwwMj90y9fLTy5xWxbdaBpYo=";
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
    maintainers = [ ];
  };
}
