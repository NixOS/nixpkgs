{
  lib,
  buildPythonPackage,
  distutils,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "lottie";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hTBKwVLNBCyf6YpSe10TajHG/iqs2FnOHFgYm7lG0Sc=";
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
