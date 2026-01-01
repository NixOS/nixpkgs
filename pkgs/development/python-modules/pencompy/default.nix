{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pencompy";
  version = "0.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PjALTsk0Msv3g8M6k0v6ftzDAuFKyIPSpfvT8S3YL48=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pencompy" ];

<<<<<<< HEAD
  meta = {
    description = "Library for interacting with Pencom relay boards";
    homepage = "https://github.com/dubnom/pencompy";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library for interacting with Pencom relay boards";
    homepage = "https://github.com/dubnom/pencompy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
