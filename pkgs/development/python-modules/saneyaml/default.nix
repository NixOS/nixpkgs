{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools-scm,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "saneyaml";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gc+9i/lNcwmYFix5D+XOyau1MAzFiQ/jfcbbyqj7Frs=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  dependencies = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "saneyaml" ];

  meta = {
    description = "PyYaml wrapper with sane behaviour to read and write readable YAML safely";
    homepage = "https://github.com/nexB/saneyaml";
    changelog = "https://github.com/aboutcode-org/saneyaml/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
