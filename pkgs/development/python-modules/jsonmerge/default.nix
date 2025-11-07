{
  lib,
  buildPythonPackage,
  fetchPypi,
  jsonschema,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jsonmerge";
  version = "1.9.2";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xDdX4BgLDhm3rkwTCtQqB8xYDDGRL2H0gj6Ory+jlKM=";
  };

  propagatedBuildInputs = [ jsonschema ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Merge a series of JSON documents";
    homepage = "https://github.com/avian2/jsonmerge";
    changelog = "https://github.com/avian2/jsonmerge/blob/jsonmerge-${version}/ChangeLog";
    license = licenses.mit;
    maintainers = [ ];
  };
}
