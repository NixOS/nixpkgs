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
    hash = "sha256-cAkmdb2hT97DOzG6d+dUPendyI8uW5kWA5ZXLRFSW9s=";
  };

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yaml_env_tag" ];

  meta = with lib; {
    description = "Custom YAML tag for referencing environment variables";
    homepage = "https://github.com/waylan/pyyaml-env-tag";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
