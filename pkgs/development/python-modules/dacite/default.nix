{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dacite";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "konradhalas";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nv2bnj3bq2v08ac4p583cnpjq2d6bv5isycgji5i5wg1y082a3d";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/konradhalas/dacite/issues/167
    "test_from_dict_with_union_and_wrong_data"
  ];

  pythonImportsCheck = [
    "dacite"
  ];

  meta = with lib; {
    description = "Python helper to create data classes from dictionaries";
    homepage = "https://github.com/konradhalas/dacite";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
