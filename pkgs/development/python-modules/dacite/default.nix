{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dacite";
  version = "1.6.0";
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

  pythonImportsCheck = [ "dacite" ];

  meta = with lib; {
    description = "Python helper to create data classes from dictionaries";
    homepage = "https://github.com/konradhalas/dacite";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
