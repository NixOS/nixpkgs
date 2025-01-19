{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyyaml-env-tag";
  version = "0.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "pyyaml_env_tag";
    inherit version;
    sha256 = "1nsva88jsmwn0cb9jnrfiz4dvs9xakkpgfii7g1xwkx1pmsjc2bh";
  };

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yaml_env_tag" ];

  meta = {
    description = "Custom YAML tag for referencing environment variables";
    homepage = "https://github.com/waylan/pyyaml-env-tag";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
