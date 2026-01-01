{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "rjsmin";
<<<<<<< HEAD
  version = "1.2.5";
=======
  version = "1.2.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-o/gECwJz3sdz4OgH6GpNCpU1UWwKCjWqG7bebhW7Hwk=";
=======
    hash = "sha256-/8vgTg36w5zqj7vLQcOLLgcjXOIYi8oV6ZjaHTSKeGA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # The package does not ship tests, and the setup machinery confuses
  # tests auto-discovery
  doCheck = false;

  pythonImportsCheck = [ "rjsmin" ];

<<<<<<< HEAD
  meta = {
    description = "Module to minify Javascript";
    homepage = "http://opensource.perlig.de/rjsmin/";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Module to minify Javascript";
    homepage = "http://opensource.perlig.de/rjsmin/";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
