{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "easyprocess";
  version = "1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "EasyProcess";
    inherit version;
    hash = "sha256-iFiYMCpXqrlIlz6LXTKkIpOSufstmGqx1P/VkOW6kOw=";
  };

  # No tests
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Easy to use python subprocess interface";
    homepage = "https://github.com/ponty/EasyProcess";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ layus ];
=======
  meta = with lib; {
    description = "Easy to use python subprocess interface";
    homepage = "https://github.com/ponty/EasyProcess";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
