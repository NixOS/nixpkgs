{ stdenv, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Durus";
  version = "4.2";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256:1gzxg43zawwgqjrfixvcrilwpikb1ix9b7710rsl5ffk7q50yi3c";
  };

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
    homepage = "https://github.com/nascheme/durus";
    license = licenses.mit;
    maintainers = with maintainers; [ grindhold ];
  };
}
