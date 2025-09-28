{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyyaml-env-tag";
  version = "1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pyyaml_env_tag";
    inherit version;
    sha256 = "sha256-LrOLdaLSHuBHXW2X7BnGMoen4UAjHkIUlp0OrJI81/8=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yaml_env_tag" ];

  meta = with lib; {
    description = "Custom YAML tag for referencing environment variables";
    homepage = "https://github.com/waylan/pyyaml-env-tag";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
