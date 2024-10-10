{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  biothings-client,
  requests,
  with-pandas ? false,
  pandas,
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

  build-system = [ setuptools ];
  dependencies = [
    biothings-client
    requests
  ] ++ (if with-pandas then [ pandas ] else [ ]);
  pythonImportsCheck = [ "mygene" ] ++ (if with-pandas then [ "pandas" ] else [ ]);

  meta = {
    changelog = "https://github.com/biothings/mygene.py/blob/v${version}/CHANGES.txt";
    description = "REST web services to query/retrieve gene annotation data";
    homepage = "https://github.com/biothings/mygene.py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rayhem ];
  };
}
