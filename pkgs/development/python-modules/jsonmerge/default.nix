{ lib
, buildPythonPackage
, fetchPypi
, jsonschema
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonmerge";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-otH4ACHFwdcKSeMfhitfBo+dsGYIDYVh6AZU3nSjWE0=";
  };

  propagatedBuildInputs = [ jsonschema ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Fails with "Unresolvable JSON pointer"
    "test_local_reference_in_meta"
  ];

  meta = with lib; {
    description = "Merge a series of JSON documents";
    homepage = "https://github.com/avian2/jsonmerge";
    changelog = "https://github.com/avian2/jsonmerge/blob/jsonmerge-${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ emily ];
  };
}
