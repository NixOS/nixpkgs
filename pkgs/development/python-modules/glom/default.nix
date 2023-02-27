{ lib
, attrs
, boltons
, buildPythonPackage
, face
, fetchPypi
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "glom";
  version = "22.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FRDGWHqPnGSiRmQbcAM8vF696Z8CrSRWk2eAOOghrrU=";
  };

  propagatedBuildInputs = [
    boltons
    attrs
    face
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  preCheck = ''
    # test_cli.py checks the output of running "glom"
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # Test is outdated (was made for PyYAML 3.x)
    "test_main_yaml_target"
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    "test_regular_error_stack"
    "test_long_target_repr"
  ];

  pythonImportsCheck = [
    "glom"
  ];

  meta = with lib; {
    description = "Restructuring data, the Python way";
    longDescription = ''
      glom helps pull together objects from other objects in a
      declarative, dynamic, and downright simple way.
    '';
    homepage = "https://github.com/mahmoud/glom";
    changelog = "https://github.com/mahmoud/glom/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
  };
}
