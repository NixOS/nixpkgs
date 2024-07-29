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
  version = "24.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XQ/fnmgQNvsmOng9Apj8OvWApuKmzxozFP/EjcPZHMs=";
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
