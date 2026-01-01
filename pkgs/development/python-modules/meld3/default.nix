{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "meld3";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ea266994f1aa83507679a67b493b852c232a7905e29440a6b868558cad5e775";
  };

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "HTML/XML templating engine used by supervisor";
    homepage = "https://github.com/supervisor/meld3";
    license = lib.licenses.free;
=======
  meta = with lib; {
    description = "HTML/XML templating engine used by supervisor";
    homepage = "https://github.com/supervisor/meld3";
    license = licenses.free;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
