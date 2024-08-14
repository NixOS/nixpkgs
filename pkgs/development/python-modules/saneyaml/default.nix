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
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gc+9i/lNcwmYFix5D+XOyau1MAzFiQ/jfcbbyqj7Frs=";
  };

  dontConfigure = true;

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "saneyaml" ];

  meta = with lib; {
    description = "PyYaml wrapper with sane behaviour to read and write readable YAML safely";
    homepage = "https://github.com/nexB/saneyaml";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
