{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openrgb-python";
  version = "0.3.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-86jy8hoOgQocdCeapjaRFO9PKx/TW9kcN16UKSWNVps=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "openrgb" ];

<<<<<<< HEAD
  meta = {
    description = "Module for the OpenRGB SDK";
    homepage = "https://openrgb-python.readthedocs.io/";
    changelog = "https://github.com/jath03/openrgb-python/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module for the OpenRGB SDK";
    homepage = "https://openrgb-python.readthedocs.io/";
    changelog = "https://github.com/jath03/openrgb-python/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
