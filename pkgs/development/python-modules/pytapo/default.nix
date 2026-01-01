{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycryptodome,
  python-kasa,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
  rtp,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pytapo";
<<<<<<< HEAD
  version = "3.3.54";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B31PTYqXFzLkn/YuFbq0G7SDA1wMqAcwGOaj3xfmxYA=";
=======
  version = "3.3.51";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pog5q/tXNz+RRZXJdb2/qG3BeaHUTYtlzOkM5Twr6js=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodome
    python-kasa
    requests
    rtp
    urllib3
  ];

  pythonImportsCheck = [ "pytapo" ];

  # Tests require actual hardware
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Python library for communication with Tapo Cameras";
    homepage = "https://github.com/JurajNyiri/pytapo";
    changelog = "https://github.com/JurajNyiri/pytapo/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fleaz ];
=======
  meta = with lib; {
    description = "Python library for communication with Tapo Cameras";
    homepage = "https://github.com/JurajNyiri/pytapo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fleaz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
