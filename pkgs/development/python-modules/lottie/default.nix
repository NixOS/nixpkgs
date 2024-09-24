{
  lib,
  buildPythonPackage,
  distutils,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "lottie";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oyQvi6NwUfvddQPs0WggOgjkrybxe+LsygimSvHn08E=";
  };

  build-system = [ setuptools ];

  dependencies = [ distutils ];

  pythonImportsCheck = [ "lottie" ];

  meta = with lib; {
    description = "Framework to work with lottie files and telegram animated stickers (tgs)";
    homepage = "https://gitlab.com/mattbas/python-lottie/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
