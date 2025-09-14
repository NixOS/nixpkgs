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
  version = "25.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ROmTsFogb8rCS4r64S33PG9mAlq0X9fFOj7eCp12Zs=";
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
