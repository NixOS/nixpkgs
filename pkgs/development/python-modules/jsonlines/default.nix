{
  lib,
  attrs,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonlines";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wbolster";
    repo = "jsonlines";
    rev = version;
    hash = "sha256-KNEJdAxEgd0NGPnk9J51C3yUN2e6Cvvevth0iKOMlhE=";
  };

  build-system = [ setuptools ];

  dependencies = [ attrs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonlines" ];

  meta = {
    description = "Python library to simplify working with jsonlines and ndjson data";
    homepage = "https://github.com/wbolster/jsonlines";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
