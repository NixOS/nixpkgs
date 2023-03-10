{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "class-registry";
  version = "3.0.5";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "todofixthis";
    repo = pname;
    rev = version;
    sha256 = "0gpvq4a6qrr2iki6b4vxarjr1jrsw560m2qzm5bb43ix8c8b7y3q";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "class_registry"
  ];

  meta = with lib; {
    description = "Factory and registry pattern for Python classes";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ kevincox SuperSandro2000 ];
  };
}
