{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "durus";
  version = "4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aQM0I26juo2WbjrszgJUd5CdayQNCzID0zJ/YkNyYAc=";
  };

  build-system = [ setuptools ];

  # Checks disabled due to missing python unittest framework 'sancho' in nixpkgs
  doCheck = false;

  pythonImportsCheck = [
    "durus.connection"
    "durus.file_storage"
    "durus.client_storage"
    "durus.sqlite_storage"
  ];

  meta = with lib; {
    description = "Object persistence layer";
    mainProgram = "durus";
    homepage = "https://github.com/nascheme/durus";
    license = licenses.mit;
    maintainers = with maintainers; [ grindhold ];
  };
}
