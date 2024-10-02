{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "jsondiff";
  version = "2.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZY0WLIqGuobeJjA82Gp7N+GyweyYtWmmDiymGAVF9/4=";
  };

  postPatch = ''
    sed -e "/'jsondiff=jsondiff.cli:main_deprecated',/d" -i setup.py
  '';

  # No tests
  doCheck = false;

  meta = {
    description = "Diff JSON and JSON-like structures in Python";
    mainProgram = "jdiff";
    homepage = "https://github.com/ZoomerAnalytics/jsondiff";
    license = lib.licenses.mit;
  };
}
