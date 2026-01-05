{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "reretry";
  version = "0.11.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8nkfzr5RLqLx0VOih0d4UjqAZIYLWRzZCvwhqL7UMuM=";
  };

  meta = {
    description = "Easy to use retry decorator";
    homepage = "https://github.com/leshchenko1979/reretry";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ renatoGarcia ];
  };
}
