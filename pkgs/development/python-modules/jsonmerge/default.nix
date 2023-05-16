{ lib
, buildPythonPackage
, fetchPypi
, jsonschema
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonmerge";
<<<<<<< HEAD
  version = "1.9.2";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xDdX4BgLDhm3rkwTCtQqB8xYDDGRL2H0gj6Ory+jlKM=";
=======
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-otH4ACHFwdcKSeMfhitfBo+dsGYIDYVh6AZU3nSjWE0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ jsonschema ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
=======
  disabledTests = [
    # Fails with "Unresolvable JSON pointer"
    "test_local_reference_in_meta"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Merge a series of JSON documents";
    homepage = "https://github.com/avian2/jsonmerge";
    changelog = "https://github.com/avian2/jsonmerge/blob/jsonmerge-${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ emily ];
  };
}
