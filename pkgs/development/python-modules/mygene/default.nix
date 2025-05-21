{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,

  # Dependencies
  biothings-client,
  pandas,
  requests,
}:
buildPythonPackage rec {
  pname = "mygene";
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biothings";
    repo = "mygene.py";
    rev = "v${version}";
    hash = "sha256-/KxlzOTbZTN5BA0PrJyivVFh4cLtW90/EFwczda61Tg=";
  };

  optional-dependencies = {
    complete = [ pandas ];
  };

  build-system = [ setuptools ];
  dependencies = [
    biothings-client
    requests
  ];
  pythonImportsCheck = [ "mygene" ];

  meta = {
    changelog = "https://github.com/biothings/mygene.py/blob/v${version}/CHANGES.txt";
    description = "REST web services to query/retrieve gene annotation data";
    homepage = "https://github.com/biothings/mygene.py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rayhem ];
  };
}
