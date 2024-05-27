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
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sjCfeDZiPNbbkyV067xD4/ZcdD52NReeZL7ssNFibkQ=";
  };

  dontConfigure = true;

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "saneyaml" ];

  meta = with lib; {
    description = "A PyYaml wrapper with sane behaviour to read and write readable YAML safely";
    homepage = "https://github.com/nexB/saneyaml";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
