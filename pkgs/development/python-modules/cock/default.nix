{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  sortedcontainers,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "cock";
  version = "0.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hi8aFxATsYcEO6qNzZnF73V8WLTQjb6Dw2xF4VgT2o4=";
  };

  propagatedBuildInputs = [
    click
    sortedcontainers
    pyyaml
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/pohmelie/cock";
    description = "Configuration file with click";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/pohmelie/cock";
    description = "Configuration file with click";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
