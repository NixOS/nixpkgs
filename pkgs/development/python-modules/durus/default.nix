{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "durus";
  version = "4.2";

  src = fetchPypi {
    pname = "Durus";
    inherit version;
    hash = "sha256:1gzxg43zawwgqjrfixvcrilwpikb1ix9b7710rsl5ffk7q50yi3c";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/nascheme/durus/commit/501a802d3763a6091b97d2f7737e59bf133e88ba.patch";
      hash = "sha256-s4Lxuts3uVcGCrPOxrqHPS+SERJ7CH3ANBLb4dc3+mI=";
    })
  ];

  # Checks disabled due to missing python unittest framework 'sancho' in nixpkgs
  doCheck = false;

  pythonImportsCheck = [
    "durus.connection"
    "durus.file_storage"
    "durus.client_storage"
    "durus.sqlite_storage"
  ];

  meta = {
    description = "Object persistence layer";
    mainProgram = "durus";
    homepage = "https://github.com/nascheme/durus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grindhold ];
  };
}
