{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pylutron";
  version = "0.2.18";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7ZnNfa4POUTMi9sDGMyR6gu9Xpg+j/JmyWVnBBSnRSE=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pylutron" ];

  meta = {
    description = "Python library for controlling a Lutron RadioRA 2 system";
    homepage = "https://github.com/thecynic/pylutron";
    changelog = "https://github.com/thecynic/pylutron/releases/tag/${version}";
    license = with lib.licenses; [
      mit
      psfl
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
