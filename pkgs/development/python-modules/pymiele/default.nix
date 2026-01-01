{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymiele";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-IqKJhuAT8UYStqy+2NQ9u4ezHBPum6vNnN42+hq7kZc=";
=======
    hash = "sha256-X2nATBOOq+N4ptF2NCNbZLi2KweoMzw0ixwP5mXm9SI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "pymiele" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/astrandb/pymiele/releases/tag/v${version}";
    description = "Lib for Miele integration with Home Assistant";
    homepage = "https://github.com/astrandb/pymiele";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
=======
  meta = with lib; {
    changelog = "https://github.com/astrandb/pymiele/releases/tag/v${version}";
    description = "Lib for Miele integration with Home Assistant";
    homepage = "https://github.com/astrandb/pymiele";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
