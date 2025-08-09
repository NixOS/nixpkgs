{
  lib,
  attrs,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jsonlines";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "wbolster";
    repo = "jsonlines";
    rev = version;
    hash = "sha256-KNEJdAxEgd0NGPnk9J51C3yUN2e6Cvvevth0iKOMlhE=";
  };

  propagatedBuildInputs = [ attrs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonlines" ];

  meta = with lib; {
    description = "Python library to simplify working with jsonlines and ndjson data";
    homepage = "https://github.com/wbolster/jsonlines";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
