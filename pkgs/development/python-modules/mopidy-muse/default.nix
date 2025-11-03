{
  lib,
  buildPythonPackage,
  fetchPypi,
  mopidy,
  setuptools,
  pykka,
}:

buildPythonPackage rec {
  pname = "mopidy-muse";
  version = "0.0.33";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Muse";
    hash = "sha256-CEPAPWtMrD+HljyqBB6EAyGVeOjzkvVoEywlE4XEJGs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mopidy
    pykka
  ];

  pythonImportsCheck = [ "mopidy_muse" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Mopidy web client with Snapcast support";
    homepage = "https://github.com/cristianpb/muse";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
